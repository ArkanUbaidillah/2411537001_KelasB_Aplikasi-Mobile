import 'package:flutter/material.dart';

// Placeholder halaman Profil sesuai modul (Center + Text).
// Versi lengkap (avatar, nama, email, logout) ada di profile_tugas_screen.dart.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Halaman Profil", style: TextStyle(fontSize: 24)),
    );
  }
}
