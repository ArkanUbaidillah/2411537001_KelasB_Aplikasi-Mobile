import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'transaction_detail_screen.dart';

// Desain sama dengan Dashboard Modul 4; data saldo dan transaksi dibaca dari SQLite.
class DashboardTugasScreen extends StatefulWidget {
  final AppUser user;
  const DashboardTugasScreen({super.key, required this.user});

  @override
  State<DashboardTugasScreen> createState() => _DashboardTugasScreenState();
}

class _DashboardTugasScreenState extends State<DashboardTugasScreen> {
  int _balance = 0;
  List<TransactionItem> _recent = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper.instance;
    final balance = await db.getBalance(widget.user.id);
    final recent = await db.getTransactions(widget.user.id, limit: 5);
    if (!mounted) return;
    setState(() {
      _balance = balance;
      _recent = recent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Keuangan'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      // Tombol mengambang (FAB) untuk tambah transaksi
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          // Memanggil Rute yang sudah didaftarkan di main_tugas.dart
          final saved = await Navigator.pushNamed(context, '/add',
              arguments: widget.user.id);
          // Muat ulang data jika transaksi baru tersimpan
          if (saved == true) _loadData();
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halo, ${widget.user.name}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildBalanceCard(),
            const SizedBox(height: 20),
            const Text('Transaksi Terakhir',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTransactionList(context), // Mengirim context untuk navigasi
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    // SizedBox selebar layar agar kartu saldo responsif mengikuti lebar layar
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        color: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Saldo Utama',
                  style: TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 8),
              Text(formatRupiah(_balance),
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    if (_recent.isEmpty) {
      return const Card(
        elevation: 2,
        child: ListTile(title: Text('Belum ada transaksi')),
      );
    }
    return Card(
      elevation: 2,
      child: Column(
        children: [
          for (int i = 0; i < _recent.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            buildTransactionTile(context, _recent[i]),
          ],
        ],
      ),
    );
  }
}

// ListTile transaksi bergaya Modul 4, dipakai juga di halaman Riwayat
Widget buildTransactionTile(BuildContext context, TransactionItem item) {
  return ListTile(
    leading: CircleAvatar(
        backgroundColor: transactionColor(item),
        child: Icon(transactionIcon(item), color: Colors.white)),
    title: Text(item.title),
    subtitle: Text(subtitleTanggal(item.date)),
    trailing: Text(item.amountText,
        style: TextStyle(
            color: item.isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold)),
    onTap: () {
      // NAVIGASI PUSH DENGAN DATA (Passing Data)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionDetailScreen(
            title: item.title,
            amount: item.amountText,
            category: item.category,
            date: formatTanggal(item.date),
          ),
        ),
      );
    },
  );
}
