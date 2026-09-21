// TUGAS Praktikum 3: menambah input Tanggal Transaksi (wajib diisi, bisa pakai showDatePicker).
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  // GlobalKey untuk mengontrol form dan memicu validasi
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengambil teks dari input
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController(); // TUGAS: tanggal transaksi

  // State untuk Dropdown
  String _selectedCategory = 'Makanan';
  final List<String> _categories = ['Makanan', 'Transportasi', 'Hiburan', 'Lainnya'];

  @override
  void dispose() {
    // Bersihkan controller saat halaman ditutup untuk mencegah memory leak
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // TUGAS: ubah DateTime menjadi teks DD/MM/YYYY
  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

  // TUGAS: cek teks berformat DD/MM/YYYY dan tanggalnya benar-benar ada
  bool _isValidDate(String text) {
    final match = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(text);
    if (match == null) return false;
    final day = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final year = int.parse(match.group(3)!);
    final date = DateTime(year, month, day);
    return date.year == year && date.month == month && date.day == day;
  }

  // TUGAS: buka kalender dengan showDatePicker
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = _formatDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catat Transaksi Baru"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      // SingleChildScrollView mencegah error layout saat keyboard muncul
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input 1: Judul Transaksi
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Judul Transaksi",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Judul transaksi tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Input 2: Nominal Saldo (Keyboard Angka)
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Nominal (Rp)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nominal wajib diisi";
                  }
                  if (int.tryParse(value) == null) {
                    return "Harus berupa angka bulat yang valid";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Input 3: Kategori Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Kategori",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // TUGAS - Input 4: Tanggal Transaksi (DD/MM/YYYY) + tombol kalender
              TextFormField(
                controller: _dateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: "Tanggal Transaksi",
                  hintText: "DD/MM/YYYY",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_month),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    tooltip: 'Pilih tanggal',
                    onPressed: _pickDate,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Tanggal wajib diisi";
                  }
                  if (!_isValidDate(value.trim())) {
                    return "Format tanggal harus DD/MM/YYYY";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Tombol Simpan
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Jalankan validasi
                  if (_formKey.currentState!.validate()) {
                    // Jika lolos validasi, tampilkan pop-up SnackBar sukses
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Tersimpan: ${_titleController.text} (Rp ${_amountController.text}) - ${_dateController.text}',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text(
                  "Simpan Transaksi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
