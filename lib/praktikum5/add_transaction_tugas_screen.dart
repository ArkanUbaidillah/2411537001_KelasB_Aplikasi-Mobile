import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';

// Desain sama dengan form tugas Modul 4 (Judul, Nominal, Tanggal);
// bedanya data sekarang disimpan ke SQLite.
class AddTransactionTugasScreen extends StatefulWidget {
  const AddTransactionTugasScreen({super.key});

  @override
  State<AddTransactionTugasScreen> createState() =>
      _AddTransactionTugasScreenState();
}

class _AddTransactionTugasScreenState extends State<AddTransactionTugasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Menampilkan date picker lalu mengisi field tanggal dengan format DD/MM/YYYY
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      setState(() {
        _dateController.text = '$day/$month/$year';
      });
    }
  }

  // Ubah teks DD/MM/YYYY menjadi DateTime; null jika format/tanggal tidak valid
  DateTime? _parseDate(String text) {
    final match = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(text.trim());
    if (match == null) return null;
    final day = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final year = int.parse(match.group(3)!);
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  // Validasi tanggal: wajib diisi dan berformat DD/MM/YYYY
  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Tanggal wajib diisi";
    }
    if (_parseDate(value) == null) {
      return "Format harus DD/MM/YYYY";
    }
    return null;
  }

  Future<void> _save() async {
    final db = DatabaseHelper.instance;
    // userId dikirim dari Dashboard lewat arguments pushNamed
    final args = ModalRoute.of(context)?.settings.arguments;
    final userId = args is int ? args : (await db.getSessionUser())?.id;
    if (userId == null) return;

    await db.insertTransaction(TransactionItem(
      userId: userId,
      title: _titleController.text.trim(),
      amount: int.parse(_amountController.text),
      type: 'pengeluaran',
      category: 'Pengeluaran',
      date: _parseDate(_dateController.text)!,
    ));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Transaksi Berhasil Disimpan!'),
          backgroundColor: Colors.green),
    );
    // NAVIGASI POP: Kembali ke halaman sebelumnya (Dashboard)
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catat Transaksi"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                    labelText: "Judul", border: OutlineInputBorder()),
                validator: (value) =>
                    value!.trim().isEmpty ? "Tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Nominal", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Tidak boleh kosong";
                  if (int.tryParse(value) == null) return "Harus berupa angka";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: "Tanggal Transaksi",
                  hintText: "DD/MM/YYYY",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate, // membuka showDatePicker
                  ),
                ),
                validator: _validateDate,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _save(); // Simpan ke SQLite
                  }
                },
                child: const Text("Simpan", style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
