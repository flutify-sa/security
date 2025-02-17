import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'package:security/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized
  await Supabase.initialize(
    url:
        'https://pqfpvdapdeypjliidwzp.supabase.co', // Replace with your Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBxZnB2ZGFwZGV5cGpsaWlkd3pwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk2OTM1MzYsImV4cCI6MjA1NTI2OTUzNn0.gcNJ6JGiTkNlTQW-H2XTVds2S5aN41xQjoHmFpKUtN0', // Replace with your Supabase Anon Key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Women’s Security App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
