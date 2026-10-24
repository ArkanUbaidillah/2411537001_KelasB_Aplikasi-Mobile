import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models.dart';

// Local storage SQLite: menyimpan akun pengguna, sesi login, dan transaksi
// sehingga data tidak hilang ketika aplikasi ditutup.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;

  Future<Database> get database async => _db ??= await _openDatabase();

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'expense_tracker.db'),
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            amount INTEGER NOT NULL,
            type TEXT NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
          )
        ''');
        // Hanya satu baris (id = 1) untuk menyimpan pengguna yang sedang login
        await db.execute('''
          CREATE TABLE session (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            user_id INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // Password tidak disimpan mentah, melainkan hash SHA-256
  String _hashPassword(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  // ===================== AKUN =====================

  // Mengembalikan null jika email sudah terdaftar
  Future<AppUser?> register(String name, String email, String password) async {
    final db = await database;
    final cleanEmail = email.trim().toLowerCase();

    final existing =
        await db.query('users', where: 'email = ?', whereArgs: [cleanEmail]);
    if (existing.isNotEmpty) return null;

    final now = DateTime.now();
    final id = await db.insert('users', {
      'name': name.trim(),
      'email': cleanEmail,
      'password': _hashPassword(password),
      'created_at': now.toIso8601String(),
    });

    // Data awal akun baru: sama dengan contoh transaksi di Dashboard Modul 4
    await insertTransaction(TransactionItem(
      userId: id,
      title: 'Gaji Bulanan',
      amount: 5000000,
      type: 'pemasukan',
      category: 'Pemasukan',
      date: DateTime(now.year, now.month, 1),
    ));
    await insertTransaction(TransactionItem(
      userId: id,
      title: 'Makan Siang',
      amount: 50000,
      type: 'pengeluaran',
      category: 'Makanan',
      date: DateTime(now.year, now.month, now.day),
    ));

    return AppUser(id: id, name: name.trim(), email: cleanEmail);
  }

  // Mengembalikan null jika email atau password salah
  Future<AppUser?> login(String email, String password) async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), _hashPassword(password)],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return AppUser.fromMap(rows.first);
  }

  // ===================== SESI LOGIN =====================

  Future<void> saveSession(int userId) async {
    final db = await database;
    await db.insert(
      'session',
      {'id': 1, 'user_id': userId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<AppUser?> getSessionUser() async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT users.* FROM session
      JOIN users ON users.id = session.user_id
      WHERE session.id = 1
    ''');
    if (rows.isEmpty) return null;
    return AppUser.fromMap(rows.first);
  }

  Future<void> clearSession() async {
    final db = await database;
    await db.delete('session');
  }

  // ===================== TRANSAKSI =====================

  Future<int> insertTransaction(TransactionItem item) async {
    final db = await database;
    return db.insert('transactions', item.toMap());
  }

  // Urut dari tanggal terbaru; limit opsional untuk "Transaksi Terakhir"
  Future<List<TransactionItem>> getTransactions(int userId, {int? limit}) async {
    final db = await database;
    final rows = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC, id DESC',
      limit: limit,
    );
    return rows.map((row) => TransactionItem.fromMap(row)).toList();
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // Saldo = total pemasukan - total pengeluaran
  Future<int> getBalance(int userId) async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT COALESCE(SUM(CASE WHEN type = 'pemasukan' THEN amount ELSE -amount END), 0) AS balance
      FROM transactions WHERE user_id = ?
    ''', [userId]);
    return (rows.first['balance'] as num).toInt();
  }
}
