import 'package:flutter/material.dart';
import 'screens/portfolio_screen.dart';
import 'models/portfolio_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Portfolio data based on course requirements
    final portfolioData = PortfolioData( 
      name: 'Daniel', // User should replace with their name
      title: 'Level 300 BSc. Computer Science Student',
      bio: 'I am a passionate Computer Science student at Valley View University, currently in my 300 level. My goal is to become a proficient mobile app developer, creating solutions that impact lives positively. I enjoy exploring new technologies and building efficient, user-friendly applications.',
      contact: ContactInfo(
        email: 'daniel.kwabena@st.vvu.edu.gh',
        phone: '+233 123 456 789',
        github: 'github.com/daniel-dev',
        linkedin: 'linkedin.com/in/daniel-dev',
      ),
      skillGroups: [
        SkillGroup(
          category: 'Languages',
          skills: ['Dart', 'JavaScript', 'Java', 'Python', 'C++'],
        ),
        SkillGroup(
          category: 'Frameworks',
          skills: ['Flutter', 'Node.js', 'React', 'Firebase'],
        ),
        SkillGroup(
          category: 'Tools',
          skills: ['Git', 'VS Code', 'Android Studio', 'Linux'],
        ),
      ],
      education: [
        Education(
          institution: 'Valley View University',
          degree: 'BSc. Computer Science',
          year: '2024 - Present',
          relevantCourses: [
            'Object Oriented Programming (Java)',
            'Mobile Application Development',
            'Data Structures & Algorithms',
            'Database Management Systems',
            'Software Engineering',
          ],
        ),
      ],
      projects: [
        Project(
          title: 'Smart Attendance System',
          description: 'A mobile application built with Flutter that uses QR codes to track student attendance in real-time, integrated with a Cloud Firestore backend.',
          technologies: ['Flutter', 'Firebase', 'Dart', 'API'],
        ),
        Project(
          title: 'Personal Finance Tracker',
          description: 'An application designed to help students manage their expenses and budgets with visual analytics and monthly reports.',
          technologies: ['Flutter', 'SQLite', 'Dart', 'Git'],
        ),
      ],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Professional Portfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue[800],
          secondary: Colors.blueAccent,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Modern font
      ),
      home: PortfolioScreen(data: portfolioData),
    );
  }
}
