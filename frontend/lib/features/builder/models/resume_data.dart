import 'package:uuid/uuid.dart';

/// Main resume data model matching backend JSON structure
class ResumeData {
  Profile? profile;
  List<Education> education;
  List<Experience> experience;
  List<Project> projects;
  Skills? skills;
  List<Leadership> leadership;
  List<String> achievements;

  ResumeData({
    this.profile,
    this.education = const [],
    this.experience = const [],
    this.projects = const [],
    this.skills,
    this.leadership = const [],
    this.achievements = const [],
  });

  // JSON serialization
  Map<String, dynamic> toJson() => {
    'profile': profile?.toJson(),
    'education': education.map((e) => e.toJson()).toList(),
    'experience': experience.map((e) => e.toJson()).toList(),
    'projects': projects.map((e) => e.toJson()).toList(),
    'skills': skills?.toJson(),
    'leadership': leadership.map((e) => e.toJson()).toList(),
    'achievements': achievements,
  };

  factory ResumeData.fromJson(Map<String, dynamic> json) => ResumeData(
    profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    education:
        (json['education'] as List?)
            ?.map((e) => Education.fromJson(e))
            .toList() ??
        [],
    experience:
        (json['experience'] as List?)
            ?.map((e) => Experience.fromJson(e))
            .toList() ??
        [],
    projects:
        (json['projects'] as List?)?.map((e) => Project.fromJson(e)).toList() ??
        [],
    skills: json['skills'] != null ? Skills.fromJson(json['skills']) : null,
    leadership:
        (json['leadership'] as List?)
            ?.map((e) => Leadership.fromJson(e))
            .toList() ??
        [],
    achievements: List<String>.from(json['achievements'] ?? []),
  );

  // Create empty instance
  factory ResumeData.empty() => ResumeData(
    profile: Profile.empty(),
    education: [Education.empty()],
    experience: [],
    projects: [],
    skills: Skills.empty(),
    leadership: [],
    achievements: [],
  );

  // Copy with method for immutability
  ResumeData copyWith({
    Profile? profile,
    List<Education>? education,
    List<Experience>? experience,
    List<Project>? projects,
    Skills? skills,
    List<Leadership>? leadership,
    List<String>? achievements,
  }) => ResumeData(
    profile: profile ?? this.profile,
    education: education ?? this.education,
    experience: experience ?? this.experience,
    projects: projects ?? this.projects,
    skills: skills ?? this.skills,
    leadership: leadership ?? this.leadership,
    achievements: achievements ?? this.achievements,
  );
}

/// Profile information model
class Profile {
  String name;
  String phone;
  String email;
  String? linkedin;
  String? github;
  String? website;
  String? summary;

  Profile({
    required this.name,
    required this.phone,
    required this.email,
    this.linkedin,
    this.github,
    this.website,
    this.summary,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
    'linkedin': linkedin,
    'github': github,
    'website': website,
    'summary': summary,
  };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    name: json['name'] ?? '',
    phone: json['phone'] ?? '',
    email: json['email'] ?? '',
    linkedin: json['linkedin'],
    github: json['github'],
    website: json['website'],
    summary: json['summary'],
  );

  factory Profile.empty() => Profile(name: '', phone: '', email: '');

  Profile copyWith({
    String? name,
    String? phone,
    String? email,
    String? linkedin,
    String? github,
    String? website,
    String? summary,
  }) => Profile(
    name: name ?? this.name,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    linkedin: linkedin ?? this.linkedin,
    github: github ?? this.github,
    website: website ?? this.website,
    summary: summary ?? this.summary,
  );
}

/// Education model
class Education {
  String id;
  String university;
  String degree;
  String date;
  String? cgpa;

  Education({
    String? id,
    required this.university,
    required this.degree,
    required this.date,
    this.cgpa,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'university': university,
    'degree': degree,
    'date': date,
    'cgpa': cgpa,
  };

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    id: json['id'],
    university: json['university'] ?? '',
    degree: json['degree'] ?? '',
    date: json['date'] ?? '',
    cgpa: json['cgpa'],
  );

  factory Education.empty() => Education(university: '', degree: '', date: '');

  Education copyWith({
    String? id,
    String? university,
    String? degree,
    String? date,
    String? cgpa,
  }) => Education(
    id: id ?? this.id,
    university: university ?? this.university,
    degree: degree ?? this.degree,
    date: date ?? this.date,
    cgpa: cgpa ?? this.cgpa,
  );
}

/// Experience model
class Experience {
  String id;
  String company;
  String role;
  String location;
  String date;
  List<String> points;

  Experience({
    String? id,
    required this.company,
    required this.role,
    required this.location,
    required this.date,
    required this.points,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'company': company,
    'role': role,
    'location': location,
    'date': date,
    'points': points,
  };

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    id: json['id'],
    company: json['company'] ?? '',
    role: json['role'] ?? '',
    location: json['location'] ?? '',
    date: json['date'] ?? '',
    points: List<String>.from(json['points'] ?? ['']),
  );

  factory Experience.empty() =>
      Experience(company: '', role: '', location: '', date: '', points: ['']);

  Experience copyWith({
    String? id,
    String? company,
    String? role,
    String? location,
    String? date,
    List<String>? points,
  }) => Experience(
    id: id ?? this.id,
    company: company ?? this.company,
    role: role ?? this.role,
    location: location ?? this.location,
    date: date ?? this.date,
    points: points ?? this.points,
  );
}

/// Project model
class Project {
  String id;
  String name;
  String? link;
  List<String> points;

  Project({String? id, required this.name, this.link, required this.points})
    : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'name': name,
    'link': link,
    'points': points,
  };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'],
    name: json['name'] ?? '',
    link: json['link'],
    points: List<String>.from(json['points'] ?? ['']),
  );

  factory Project.empty() => Project(name: '', points: ['']);

  Project copyWith({
    String? id,
    String? name,
    String? link,
    List<String>? points,
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    link: link ?? this.link,
    points: points ?? this.points,
  );
}

/// Skills model
class Skills {
  String? languages;
  String? technologies;
  String? professional;

  Skills({this.languages, this.technologies, this.professional});

  Map<String, dynamic> toJson() => {
    'languages': languages,
    'technologies': technologies,
    'professional': professional,
  };

  factory Skills.fromJson(Map<String, dynamic> json) => Skills(
    languages: json['languages'],
    technologies: json['technologies'],
    professional: json['professional'],
  );

  factory Skills.empty() =>
      Skills(languages: '', technologies: '', professional: '');

  Skills copyWith({
    String? languages,
    String? technologies,
    String? professional,
  }) => Skills(
    languages: languages ?? this.languages,
    technologies: technologies ?? this.technologies,
    professional: professional ?? this.professional,
  );
}

/// Leadership model
class Leadership {
  String id;
  String organization;
  String role;
  String date;
  List<String> points;

  Leadership({
    String? id,
    required this.organization,
    required this.role,
    required this.date,
    required this.points,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'organization': organization,
    'role': role,
    'date': date,
    'points': points,
  };

  factory Leadership.fromJson(Map<String, dynamic> json) => Leadership(
    id: json['id'],
    organization: json['organization'] ?? '',
    role: json['role'] ?? '',
    date: json['date'] ?? '',
    points: List<String>.from(json['points'] ?? ['']),
  );

  factory Leadership.empty() =>
      Leadership(organization: '', role: '', date: '', points: ['']);

  Leadership copyWith({
    String? id,
    String? organization,
    String? role,
    String? date,
    List<String>? points,
  }) => Leadership(
    id: id ?? this.id,
    organization: organization ?? this.organization,
    role: role ?? this.role,
    date: date ?? this.date,
    points: points ?? this.points,
  );
}
