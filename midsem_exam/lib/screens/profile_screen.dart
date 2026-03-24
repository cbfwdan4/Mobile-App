import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/student.dart';
import 'task_list_screen.dart';
import '../theme/app_theme.dart';

/// Screen that displays and allows editing of the student's profile information.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Default student data
  late Student _student;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Load profile from SharedPreferences
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _student = Student(
        name: prefs.getString('student_name') ?? "Kwao Daniel Kwabena",
        studentId: prefs.getString('student_id') ?? "224CS02001286",
        programme: prefs.getString('student_programme') ?? "BSc Computer Science",
        level: prefs.getInt('student_level') ?? 300,
      );
      _isLoading = false;
    });
  }

  // Save profile to SharedPreferences
  Future<void> _saveProfile(Student student) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('student_name', student.name);
    await prefs.setString('student_id', student.studentId);
    await prefs.setString('student_programme', student.programme);
    await prefs.setInt('student_level', student.level);
    
    setState(() {
      _student = student;
    });
  }

  // Show dialog to edit profile
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _student.name);
    final idController = TextEditingController(text: _student.studentId);
    final programmeController = TextEditingController(text: _student.programme);
    final levelController = TextEditingController(text: _student.level.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: "Student ID"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: programmeController,
                  decoration: const InputDecoration(labelText: "Programme"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: levelController,
                  decoration: const InputDecoration(labelText: "Level"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                final newStudent = Student(
                  name: nameController.text,
                  studentId: idController.text,
                  programme: programmeController.text,
                  level: int.tryParse(levelController.text) ?? _student.level,
                );
                _saveProfile(newStudent);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        decoration: AppTheme.mainGradient,
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator(color: AppTheme.accentIndigo)),
        ),
      );
    }

    return Container(
      decoration: AppTheme.mainGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Student Profile'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Profile Image with Glow
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.accentIndigo.withOpacity(0.5), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentIndigo.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 54,
                    backgroundColor: AppTheme.secondaryDark,
                    child: Text(
                      _student.name.isNotEmpty ? _student.name[0] : 'U',
                      style: GoogleFonts.outfit(
                        fontSize: 44,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _student.name,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _student.programme,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.accentIndigo,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              // Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.credit_card_rounded, "Student ID", _student.studentId),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(color: Colors.white10),
                      ),
                      _buildInfoRow(Icons.school_rounded, "Academic Level", _student.level.toString()),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(color: Colors.white10),
                      ),
                      _buildInfoRow(Icons.badge_rounded, "Status", "Active Student"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _showEditProfileDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryDark,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.black26,
                      ),
                      icon: const Icon(Icons.edit_note_rounded),
                      label: const Text("Edit"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TaskListScreen()),
                        );
                      },
                      icon: const Icon(Icons.task_alt_rounded),
                      label: const Text("Tasks"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.accentIndigo.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.accentIndigo, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textBody,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
