import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student.dart';
import 'task_list_screen.dart';

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
          title: const Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: "Student ID"),
                ),
                TextField(
                  controller: programmeController,
                  decoration: const InputDecoration(labelText: "Programme"),
                ),
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Text(
                _student.name.isNotEmpty ? _student.name[0] : 'U',
                style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.person, "Name", _student.name),
                    const Divider(),
                    _buildInfoRow(Icons.credit_card, "Student ID", _student.studentId),
                    const Divider(),
                    _buildInfoRow(Icons.school, "Programme", _student.programme),
                    const Divider(),
                    _buildInfoRow(Icons.trending_up, "Level", _student.level.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _showEditProfileDialog,
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TaskListScreen()),
                    );
                  },
                  icon: const Icon(Icons.list),
                  label: const Text("View Tasks"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
