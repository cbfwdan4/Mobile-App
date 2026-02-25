import 'package:flutter/material.dart';
import '../models/portfolio_data.dart';
import '../widgets/header_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/education_section.dart';
import '../widgets/projects_section.dart';

class PortfolioScreen extends StatelessWidget {
  final PortfolioData data;

  const PortfolioScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('${data.name}\'s Portfolio'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blue[900],
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return _buildTabletLayout(context);
            } else {
              return _buildMobileLayout(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderSection(
            name: data.name,
            title: data.title,
            contact: data.contact,
          ),
          const SizedBox(height: 40),
          _buildBioSection(),
          const SizedBox(height: 40),
          SkillsSection(skillGroups: data.skillGroups),
          const SizedBox(height: 40),
          EducationSection(education: data.education),
          const SizedBox(height: 40),
          ProjectsSection(projects: data.projects),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Center(
        child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column - Profile & Skills
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: HeaderSection(
                          name: data.name,
                          title: data.title,
                          contact: data.contact,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildBioSection(),
                    const SizedBox(height: 24),
                    SkillsSection(skillGroups: data.skillGroups),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // Right Column - Education & Projects
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EducationSection(education: data.education),
                    const SizedBox(height: 40),
                    ProjectsSection(projects: data.projects),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_pin, color: Colors.blue[800]),
            const SizedBox(width: 10),
            Text(
              'About Me',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              data.bio,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
