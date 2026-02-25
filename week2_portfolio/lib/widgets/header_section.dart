import 'package:flutter/material.dart';
import '../models/portfolio_data.dart';

class HeaderSection extends StatelessWidget {
  final String name;
  final String title;
  final ContactInfo contact;

  const HeaderSection({
    super.key,
    required this.name,
    required this.title,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.blue[900],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.blue[700],
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 10,
          children: [
            _buildContactItem(Icons.email, contact.email),
            _buildContactItem(Icons.link, contact.github),
          ],
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
