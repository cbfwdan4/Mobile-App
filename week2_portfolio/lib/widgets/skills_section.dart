import 'package:flutter/material.dart';
import '../models/portfolio_data.dart';

class SkillsSection extends StatelessWidget {
  final List<SkillGroup> skillGroups;

  const SkillsSection({super.key, required this.skillGroups});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.code, color: Colors.blue[800]),
            const SizedBox(width: 10),
            Text(
              'Technical Skills',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...skillGroups.map((group) => _buildSkillCategory(group)),
      ],
    );
  }

  Widget _buildSkillCategory(SkillGroup group) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.category,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: group.skills.map((skill) {
              return Chip(
                label: Text(skill),
                backgroundColor: Colors.blue[50],
                side: BorderSide(color: Colors.blue[100]!),
                labelStyle: TextStyle(color: Colors.blue[800], fontSize: 13),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
