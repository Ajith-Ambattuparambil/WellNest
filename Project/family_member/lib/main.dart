import 'package:family_member/screens/homepage.dart';
import 'package:family_member/screens/landingpage.dart';
import 'package:family_member/screens/payment.dart';
import 'package:family_member/screens/view_health.dart';
import 'package:family_member/screens/view_medappointments.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://xigidxtugemqjqxxupbq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhpZ2lkeHR1Z2VtcWpxeHh1cGJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkxODc0NTksImV4cCI6MjA1NDc2MzQ1OX0._nRKz4mIaREHLmv5mihabn9kwI180MBZIxwHbqkklQ8',
  );

  runApp(MainApp());
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Landingpage()
    );
  }
}
