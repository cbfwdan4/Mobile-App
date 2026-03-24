import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';

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
            title: "Finalize MidSem App Design",
            courseCode: "INFT 425",
            dueDate: DateTime.now().add(const Duration(days: 1)),
          ),
          Task(
            title: "Advanced Flutter Concepts",
            courseCode: "INFT 301",
            dueDate: DateTime.now().add(const Duration(days: 3)),
          ),
          Task(
            title: "Research Firebase Auth",
            courseCode: "INFT 410",
            dueDate: DateTime.now().add(const Duration(days: 7)),
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
              backgroundColor: AppTheme.secondaryDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Text("New Assignment", style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Task Title"),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: courseController,
                    decoration: const InputDecoration(labelText: "Course Code"),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                           return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: AppTheme.accentIndigo,
                                onPrimary: Colors.white,
                                surface: AppTheme.secondaryDark,
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null && picked != selectedDate) {
                        setDialogState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, color: AppTheme.accentIndigo),
                          const SizedBox(width: 12),
                          Text(
                            "Due: ${DateFormat('MMM dd, yyyy').format(selectedDate)}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
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
    return Container(
      decoration: AppTheme.mainGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Assignment Tracker'),
          actions: [
            IconButton(
              onPressed: () {}, // Potential filter
              icon: const Icon(Icons.filter_list_rounded),
            ),
          ],
        ),
        body: _tasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.task_rounded, size: 80, color: Colors.white.withOpacity(0.1)),
                    const SizedBox(height: 16),
                    const Text("No tasks found. Tap + to add one!"),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: 1.0,
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (task.isComplete ? Colors.green : AppTheme.accentIndigo).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              task.isComplete ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                              color: task.isComplete ? Colors.greenAccent : AppTheme.accentIndigo,
                            ),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: task.isComplete ? AppTheme.textBody : Colors.white,
                              decoration: task.isComplete ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentViolet.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    task.courseCode,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppTheme.accentViolet,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.access_time_rounded, size: 14, color: task.isComplete ? AppTheme.textBody : Colors.orangeAccent),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('MMM dd').format(task.dueDate),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: task.isComplete ? AppTheme.textBody : Colors.orangeAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: task.isComplete,
                              activeColor: AppTheme.accentIndigo,
                              checkColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              side: BorderSide(color: Colors.white.withOpacity(0.2)),
                              onChanged: (value) => _toggleTask(index),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentIndigo.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
          ),
          child: FloatingActionButton(
            onPressed: _showAddTaskDialog,
            backgroundColor: AppTheme.accentIndigo,
            foregroundColor: Colors.white,
            elevation: 0,
            child: const Icon(Icons.add_rounded, size: 32),
          ),
        ),
      ),
    );
  }
}
