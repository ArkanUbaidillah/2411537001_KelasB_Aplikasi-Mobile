import 'package:flutter/material.dart';

import 'user_registration_form.dart';

// TUGAS: Form pendaftaran pengguna.
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Form Pendaftaran',
      home: const UserRegistrationForm(),
    );
  }
}
