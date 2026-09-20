import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praktikum_flutter/praktikum1/main.dart' as registrasi;
import 'package:praktikum_flutter/praktikum2/main1.dart' as main1;
import 'package:praktikum_flutter/praktikum2/main1_tugas.dart' as main1_tugas;
import 'package:praktikum_flutter/praktikum2/main2.dart' as main2;
import 'package:praktikum_flutter/praktikum2/main2_tugas.dart' as main2_tugas;

void main() {
  group('Praktikum 1 (tugas)', () {
    testWidgets('Form pendaftaran menampilkan error saat kosong', (tester) async {
      await tester.pumpWidget(const registrasi.MyApp());

      await tester.tap(find.text('Daftar'));
      await tester.pump();

      expect(find.text('Masukkan nama anda'), findsOneWidget);
      expect(find.text('Masukkan email anda'), findsOneWidget);
      expect(find.text('Masukkan password anda'), findsOneWidget);
    });

    testWidgets('Form pendaftaran: password dan konfirmasi harus sama',
        (tester) async {
      await tester.pumpWidget(const registrasi.MyApp());
      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'Budi');
      await tester.enterText(fields.at(1), 'budi@mail.com');
      await tester.enterText(fields.at(2), 'rahasia1');
      await tester.enterText(fields.at(3), 'beda123');
      await tester.tap(find.text('Daftar'));
      await tester.pump();

      expect(find.text('Password tidak sama'), findsOneWidget);
    });

    testWidgets('Form pendaftaran berhasil jika semua valid', (tester) async {
      await tester.pumpWidget(const registrasi.MyApp());
      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'Budi');
      await tester.enterText(fields.at(1), 'budi@mail.com');
      await tester.enterText(fields.at(2), 'rahasia1');
      await tester.enterText(fields.at(3), 'rahasia1');
      await tester.tap(find.text('Daftar'));
      await tester.pump();

      expect(find.textContaining('Pendaftaran berhasil'), findsOneWidget);
    });
  });

  group('Praktikum 2 (modul)', () {
    testWidgets('main1: saldo bisa disembunyikan, tanpa No. Rekening',
        (tester) async {
      await tester.pumpWidget(const main1.MyApp());

      expect(find.text('No. Rekening: 1234-5678'), findsNothing);
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();
      expect(find.text('Rp *********'), findsOneWidget);
    });

    testWidgets('main2: 3 transaksi', (tester) async {
      await tester.pumpWidget(const main2.MyApp());

      expect(find.text('Transaksi Terakhir'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(3));
    });
  });

  group('Praktikum 2 (tugas)', () {
    testWidgets('main1_tugas: ada No. Rekening', (tester) async {
      await tester.pumpWidget(const main1_tugas.MyApp());

      expect(find.text('No. Rekening: 1234-5678'), findsOneWidget);
    });

    testWidgets('main2_tugas: 5 transaksi', (tester) async {
      await tester.pumpWidget(const main2_tugas.MyApp());

      expect(find.byType(ListTile), findsNWidgets(5));
      expect(find.text('Belanja Bulanan'), findsOneWidget);
      expect(find.text('Bonus Proyek'), findsOneWidget);
    });
  });
}
