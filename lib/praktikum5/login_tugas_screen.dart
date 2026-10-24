import 'package:flutter/material.dart';
import 'database_helper.dart';

class LoginTugasScreen extends StatefulWidget {
  const LoginTugasScreen({super.key});

  @override
  State<LoginTugasScreen> createState() => _LoginTugasScreenState();
}

class _LoginTugasScreenState extends State<LoginTugasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final user = await DatabaseHelper.instance
        .login(_emailController.text, _passwordController.text);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Email atau password salah'),
            backgroundColor: Colors.red),
      );
      return;
    }

    // Simpan sesi agar tetap login saat aplikasi dibuka lagi
    await DatabaseHelper.instance.saveSession(user.id);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Login berhasil sebagai ${user.email}'),
          backgroundColor: Colors.green),
    );
    // Masuk ke halaman utama dan hapus halaman login dari tumpukan
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  Future<void> _openRegister() async {
    // Halaman register mengembalikan email yang baru didaftarkan
    final email = await Navigator.pushNamed(context, '/register');
    if (email is String) {
      _emailController.text = email;
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.account_balance_wallet,
                        size: 44, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text('Expense Tracker',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Masuk untuk mengelola keuanganmu',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!value.contains('@')) {
                        return 'Email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty)
                            ? 'Password wajib diisi'
                            : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16)),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Login', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Belum punya akun?'),
                      TextButton(
                        onPressed: _openRegister,
                        child: const Text('Daftar',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
