import 'package:caretaker_wellnest/screens/homepage.dart';
import 'package:caretaker_wellnest/screens/login_page.dart';
import 'package:caretaker_wellnest/screens/resident_profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ResidentProfile()
    );
  }
}
