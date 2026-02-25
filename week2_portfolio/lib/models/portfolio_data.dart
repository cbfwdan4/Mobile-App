class PortfolioData {
  final String name;
  final String title;
  final String bio;
  final List<SkillGroup> skillGroups;
  final List<Education> education;
  final List<Project> projects;
  final ContactInfo contact;

  PortfolioData({
    required this.name,
    required this.title,
    required this.bio,
    required this.skillGroups,
    required this.education,
    required this.projects,
    required this.contact,
  });
}

class SkillGroup {
  final String category;
  final List<String> skills;

  SkillGroup({required this.category, required this.skills});
}

class Education {
  final String institution;
  final String degree;
  final String year;
  final List<String>? relevantCourses;

  Education({
    required this.institution,
    required this.degree,
    required this.year,
    this.relevantCourses,
  });
}

class Project {
  final String title;
  final String description;
  final List<String> technologies;

  Project({
    required this.title,
    required this.description,
    required this.technologies,
  });
}

class ContactInfo {
  final String email;
  final String phone;
  final String github;
  final String linkedin;

  ContactInfo({
    required this.email,
    required this.phone,
    required this.github,
    required this.linkedin,
  });
}
