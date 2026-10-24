import 'package:flutter/material.dart';
import 'database_helper.dart';

// Form register mengambil field dan validasi dari Praktikum 1
// (Nama, Email, Password, Confirm Password), lalu disimpan ke SQLite.
class RegisterTugasScreen extends StatefulWidget {
  const RegisterTugasScreen({super.key});

  @override
  State<RegisterTugasScreen> createState() => _RegisterTugasScreenState();
}

class _RegisterTugasScreenState extends State<RegisterTugasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final user = await DatabaseHelper.instance.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Email sudah terdaftar, gunakan email lain'),
            backgroundColor: Colors.red),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Registrasi berhasil, silakan login'),
          backgroundColor: Colors.green),
    );
    // Kembali ke halaman login sambil membawa email yang didaftarkan
    Navigator.pop(context, user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Masukkan nama anda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email (harus mengandung @)
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Masukkan email anda';
                  }
                  if (!value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan password anda';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm password (harus sama dengan password)
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password anda';
                  }
                  if (value != _passwordController.text) {
                    return 'Password tidak sama';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Daftar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
