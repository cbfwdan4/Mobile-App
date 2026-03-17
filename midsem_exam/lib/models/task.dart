import 'dart:convert';

/// Model class representing a Task with title, course code, due date, and completion status.
class Task {
  final String title;
  final String courseCode;
  final DateTime dueDate;
  bool isComplete;

  // Constructor with default completion status as false
  Task({
    required this.title,
    required this.courseCode,
    required this.dueDate,
    this.isComplete = false,
  });

  // Convert Task to Map for JSON storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'courseCode': courseCode,
      'dueDate': dueDate.toIso8601String(),
      'isComplete': isComplete,
    };
  }

  // Create Task from Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      courseCode: map['courseCode'],
      dueDate: DateTime.parse(map['dueDate']),
      isComplete: map['isComplete'],
    );
  }

  // Convert List<Task> to JSON string
  static String encode(List<Task> tasks) => json.encode(
    tasks.map<Map<String, dynamic>>((task) => task.toMap()).toList(),
  );

  // Decode List<Task> from JSON string
  static List<Task> decode(String tasks) =>
    (json.decode(tasks) as List<dynamic>)
      .map<Task>((item) => Task.fromMap(item))
      .toList();
}
