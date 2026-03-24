import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/event_viewmodel.dart';
import 'viewmodels/quote_viewmodel.dart';
import 'viewmodels/theme_viewmodel.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Attempting standard Firebase initialization. If already configured, this works.
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase Initialization notice: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => EventViewModel()),
        ChangeNotifierProvider(create: (_) => QuoteViewModel()..loadRandomQuote()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeVm, _) {
          return MaterialApp(
            title: 'Campus Connect',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeVm.themeMode,
            home: AuthGate(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    
    // Automatically switch between screens based on login state
    if (authVm.user != null) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
