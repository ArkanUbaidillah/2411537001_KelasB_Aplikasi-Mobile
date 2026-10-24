import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'dashboard_tugas_screen.dart'; // memakai buildTransactionTile

// Halaman Riwayat Transaksi: semua transaksi dari SQLite,
// tampilan daftar sama dengan "Transaksi Terakhir" di Dashboard.
class RiwayatTugasScreen extends StatefulWidget {
  final AppUser user;
  const RiwayatTugasScreen({super.key, required this.user});

  @override
  State<RiwayatTugasScreen> createState() => _RiwayatTugasScreenState();
}

class _RiwayatTugasScreenState extends State<RiwayatTugasScreen> {
  List<TransactionItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final items = await DatabaseHelper.instance.getTransactions(widget.user.id);
    if (!mounted) return;
    setState(() => _items = items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          child: _items.isEmpty
              ? const ListTile(title: Text('Belum ada transaksi'))
              : Column(
                  children: [
                    for (int i = 0; i < _items.length; i++) ...[
                      if (i > 0) const Divider(height: 1),
                      buildTransactionTile(context, _items[i]),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
