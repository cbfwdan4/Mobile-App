import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

/// Screen that manages and displays a list of tasks with persistence using SharedPreferences.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];
  final String _prefKey = 'task_list';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks from SharedPreferences
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString(_prefKey);
    
    if (tasksJson != null) {
      setState(() {
        _tasks = Task.decode(tasksJson);
      });
    } else {
      // Load hardcoded list if no saved data
      setState(() {
        _tasks = [
          Task(
            title: "Complete Flutter Project",
            courseCode: "INFT 425",
            dueDate: DateTime.now().add(const Duration(days: 2)),
          ),
          Task(
            title: "Study for Exam",
            courseCode: "INFT 301",
            dueDate: DateTime.now().add(const Duration(days: 5)),
          ),
          Task(
            title: "Write Research Paper",
            courseCode: "INFT 410",
            dueDate: DateTime.now().add(const Duration(days: 10)),
          ),
        ];
      });
      _saveTasks();
    }
  }

  // Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, Task.encode(_tasks));
  }

  // Add a new task
  void _addTask(String title, String courseCode, DateTime dueDate) {
    setState(() {
      _tasks.add(Task(title: title, courseCode: courseCode, dueDate: dueDate));
    });
    _saveTasks();
  }

  // Toggle task completion
  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isComplete = !_tasks[index].isComplete;
    });
    _saveTasks();
  }

  // Show dialog to add a new task
  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final courseController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add New Task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Task Title"),
                  ),
                  TextField(
                    controller: courseController,
                    decoration: const InputDecoration(labelText: "Course Code"),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Due Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}"),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != selectedDate) {
                            setDialogState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty && courseController.text.isNotEmpty) {
                      _addTask(titleController.text, courseController.text, selectedDate);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Task Manager'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text("No tasks found. Add some!"))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: task.isComplete ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      "${task.courseCode} - ${DateFormat('dd/MM/yyyy').format(task.dueDate)}",
                    ),
                    trailing: Checkbox(
                      value: task.isComplete,
                      onChanged: (value) => _toggleTask(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
