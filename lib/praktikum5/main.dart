import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'add_transaction_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker Final',
      theme: ThemeData(primarySwatch: Colors.red),
      // MENGGUNAKAN NAMED ROUTES
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/add': (context) => const AddTransactionScreen(),
      },
    );
  }
}
