import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'dashboard_tugas_screen.dart';
import 'riwayat_tugas_screen.dart';
import 'profile_tugas_screen.dart';

class MainTugasScreen extends StatefulWidget {
  const MainTugasScreen({super.key});
  @override
  State<MainTugasScreen> createState() => _MainTugasScreenState();
}

class _MainTugasScreenState extends State<MainTugasScreen> {
  int _selectedIndex = 0; // Tab pertama aktif secara default (Beranda)
  AppUser? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // Ambil data pengguna yang sedang login dari SQLite
  Future<void> _loadUser() async {
    final user = await DatabaseHelper.instance.getSessionUser();
    if (!mounted) return;
    if (user == null) {
      // Tidak ada sesi: kembali ke halaman login
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }
    setState(() => _user = user);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // List kumpulan halaman (semua membaca data dari SQLite)
    final List<Widget> pages = [
      DashboardTugasScreen(user: user),
      RiwayatTugasScreen(user: user),
      ProfileTugasScreen(user: user),
    ];

    return Scaffold(
      body: pages[_selectedIndex], // Ganti layar sesuai index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red[800],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
