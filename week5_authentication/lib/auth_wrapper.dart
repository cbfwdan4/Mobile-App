import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'firebase_options.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    Stream<User?> authStream;
    try {
      authStream = FirebaseAuth.instance.authStateChanges();
    } catch (e) {
      debugPrint('Error accessing FirebaseAuth: $e');
      return const LoginScreen();
    }

    return StreamBuilder<User?>(
      stream: authStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Check for dummy configuration
        if (DefaultFirebaseOptions.currentPlatform.apiKey == 'dummy-api-key') {
          return const ConfigErrorScreen();
        }

        // If user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          return const DashboardScreen();
        }

        // If user is not logged in
        return const LoginScreen();
      },
    );
  }
}

class ConfigErrorScreen extends StatelessWidget {
  const ConfigErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.orange),
              const SizedBox(height: 24),
              Text(
                'Firebase Not Configured',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'The "Network Error" you are seeing is because the app is using dummy Firebase keys. You must connect to your own project.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              const Text(
                'To fix this, run:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'flutterfire configure',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                   showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      title: Text('Why did it fail?'),
                      content: Text('Firebase tries to verify your identity. Since the project ID is "dummy", it attempts to reach a non-existent server, resulting in a network timeout/unreachable host error.'),
                    ),
                  );
                },
                child: const Text('Why am I seeing this?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}