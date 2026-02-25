import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/departments_screen.dart';
import 'screens/department_detail_screen.dart';
import 'screens/faculty_screen.dart';

void main() {
  runApp(const CampusDirectoryApp());
}

class CampusDirectoryApp extends StatelessWidget {
  const CampusDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VVU Campus Directory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/departments': (context) => const DepartmentsScreen(),
        '/faculty': (context) => const FacultyScreen(),
        '/department/detail': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return DepartmentDetailScreen(
            departmentName: args['name']!,
          );
        },
      },
    );
  }
}
