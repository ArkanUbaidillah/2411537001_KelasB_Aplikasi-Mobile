import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';

// Halaman Profil: avatar, nama, email, dan tombol logout.
class ProfileTugasScreen extends StatelessWidget {
  final AppUser user;
  const ProfileTugasScreen({super.key, required this.user});

  Future<void> _logout(BuildContext context) async {
    // Hapus sesi; data akun dan transaksi tetap tersimpan di SQLite
    await DatabaseHelper.instance.clearSession();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(user.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(user.email,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Logout', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
