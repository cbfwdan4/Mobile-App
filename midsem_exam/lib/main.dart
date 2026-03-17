import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

// Entry point of the application
void main() async {
  // Ensure that widget binding is initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (Note: In a real app, you would pass options)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase initialization error: $e");
    // We continue even if Firebase fails since we are not using real Auth in this exam
  }

  runApp(const StudentTaskApp());
}

class StudentTaskApp extends StatelessWidget {
  const StudentTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Profile & Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Start with the Login Screen
      home: const LoginScreen(),
    );
  }
}
