import 'package:flutter/material.dart';
import '../models/portfolio_data.dart';

class ProjectsSection extends StatelessWidget {
  final List<Project> projects;

  const ProjectsSection({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.workspace_premium, color: Colors.blue[800]),
            const SizedBox(width: 10),
            Text(
              'Projects & Experience',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...projects.map((proj) => _buildProjectCard(proj)),
      ],
    );
  }

  Widget _buildProjectCard(Project project) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              project.description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: project.technologies.map((tech) {
                return Icon(
                  _getIconForTech(tech),
                  size: 20,
                  color: Colors.blue[400],
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Text(
              'Tech Stack: ${project.technologies.join(", ")}',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTech(String tech) {
    final t = tech.toLowerCase();
    if (t.contains('flutter')) return Icons.flutter_dash;
    if (t.contains('firebase')) return Icons.local_fire_department;
    if (t.contains('api')) return Icons.api;
    if (t.contains('git')) return Icons.account_tree;
    if (t.contains('dart')) return Icons.data_object;
    return Icons.code;
  }
}
