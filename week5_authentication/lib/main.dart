import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth_wrapper.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authenticated User Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthWrapper(),
      // Adding routes to support pushReplacementNamed if needed by 9.3
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

