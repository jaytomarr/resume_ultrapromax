import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resume_data.dart';
import '../../../services/firestore_service.dart';
import '../../../services/auth_service.dart';

// Resume state notifier
class ResumeNotifier extends StateNotifier<ResumeData> {
  final FirestoreService _firestoreService;
  final AuthService _authService;

  ResumeNotifier(this._firestoreService, this._authService)
    : super(ResumeData.empty());

  // Load data from Firestore
  Future<void> loadData() async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      final data = await _firestoreService.loadUserData(userId);
      if (data != null) {
        state = data;
      } else {
        state = ResumeData.empty();
      }
    } catch (e) {
      print('Error loading resume data: $e');
      rethrow;
    }
  }

  // Save data to Firestore
  Future<void> saveData() async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      await _firestoreService.saveUserData(userId, state);
    } catch (e) {
      print('Error saving resume data: $e');
      rethrow;
    }
  }

  // Reset all data
  Future<void> resetData() async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      await _firestoreService.deleteUserData(userId);
      state = ResumeData.empty();
    } catch (e) {
      print('Error resetting data: $e');
      rethrow;
    }
  }

  // Update profile
  void updateProfile(Profile profile) {
    state = state.copyWith(profile: profile);
  }

  // Update education
  void updateEducation(List<Education> education) {
    state = state.copyWith(education: education);
  }

  void addEducation() {
    state = state.copyWith(education: [...state.education, Education.empty()]);
  }

  void removeEducation(String id) {
    if (state.education.length <= 1) return; // Keep at least one
    state = state.copyWith(
      education: state.education.where((e) => e.id != id).toList(),
    );
  }

  // Update experience
  void updateExperience(List<Experience> experience) {
    state = state.copyWith(experience: experience);
  }

  void addExperience() {
    state = state.copyWith(
      experience: [...state.experience, Experience.empty()],
    );
  }

  void removeExperience(String id) {
    state = state.copyWith(
      experience: state.experience.where((e) => e.id != id).toList(),
    );
  }

  // Update projects
  void updateProjects(List<Project> projects) {
    state = state.copyWith(projects: projects);
  }

  void addProject() {
    state = state.copyWith(projects: [...state.projects, Project.empty()]);
  }

  void removeProject(String id) {
    state = state.copyWith(
      projects: state.projects.where((p) => p.id != id).toList(),
    );
  }

  // Update skills
  void updateSkills(Skills skills) {
    state = state.copyWith(skills: skills);
  }

  // Update leadership
  void updateLeadership(List<Leadership> leadership) {
    state = state.copyWith(leadership: leadership);
  }

  void addLeadership() {
    state = state.copyWith(
      leadership: [...state.leadership, Leadership.empty()],
    );
  }

  void removeLeadership(String id) {
    state = state.copyWith(
      leadership: state.leadership.where((l) => l.id != id).toList(),
    );
  }

  // Update achievements
  void updateAchievements(List<String> achievements) {
    state = state.copyWith(achievements: achievements);
  }

  void addAchievement() {
    state = state.copyWith(achievements: [...state.achievements, '']);
  }

  void removeAchievement(int index) {
    if (state.achievements.isEmpty) return;
    final newAchievements = List<String>.from(state.achievements);
    newAchievements.removeAt(index);
    state = state.copyWith(achievements: newAchievements);
  }

  // Add/remove points for Experience
  void addExperiencePoint(String experienceId) {
    final updatedExperience = state.experience.map((exp) {
      if (exp.id == experienceId) {
        return exp.copyWith(points: [...exp.points, '']);
      }
      return exp;
    }).toList();
    state = state.copyWith(experience: updatedExperience);
  }

  void removeExperiencePoint(String experienceId, int pointIndex) {
    final updatedExperience = state.experience.map((exp) {
      if (exp.id == experienceId && exp.points.length > 1) {
        final newPoints = List<String>.from(exp.points);
        newPoints.removeAt(pointIndex);
        return exp.copyWith(points: newPoints);
      }
      return exp;
    }).toList();
    state = state.copyWith(experience: updatedExperience);
  }

  // Add/remove points for Projects
  void addProjectPoint(String projectId) {
    final updatedProjects = state.projects.map((proj) {
      if (proj.id == projectId) {
        return proj.copyWith(points: [...proj.points, '']);
      }
      return proj;
    }).toList();
    state = state.copyWith(projects: updatedProjects);
  }

  void removeProjectPoint(String projectId, int pointIndex) {
    final updatedProjects = state.projects.map((proj) {
      if (proj.id == projectId && proj.points.length > 1) {
        final newPoints = List<String>.from(proj.points);
        newPoints.removeAt(pointIndex);
        return proj.copyWith(points: newPoints);
      }
      return proj;
    }).toList();
    state = state.copyWith(projects: updatedProjects);
  }

  // Add/remove points for Leadership
  void addLeadershipPoint(String leadershipId) {
    final updatedLeadership = state.leadership.map((lead) {
      if (lead.id == leadershipId) {
        return lead.copyWith(points: [...lead.points, '']);
      }
      return lead;
    }).toList();
    state = state.copyWith(leadership: updatedLeadership);
  }

  void removeLeadershipPoint(String leadershipId, int pointIndex) {
    final updatedLeadership = state.leadership.map((lead) {
      if (lead.id == leadershipId && lead.points.length > 1) {
        final newPoints = List<String>.from(lead.points);
        newPoints.removeAt(pointIndex);
        return lead.copyWith(points: newPoints);
      }
      return lead;
    }).toList();
    state = state.copyWith(leadership: updatedLeadership);
  }
}

// Provider for FirestoreService
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Resume provider
final resumeProvider = StateNotifierProvider<ResumeNotifier, ResumeData>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final authService = ref.watch(authServiceProvider);
  return ResumeNotifier(firestoreService, authService);
});

// UI state provider (loading, errors, etc.)
class UIState {
  final bool isLoading;
  final String? errorMessage;

  UIState({this.isLoading = false, this.errorMessage});

  UIState copyWith({bool? isLoading, String? errorMessage}) {
    return UIState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final uiStateProvider = StateProvider<UIState>((ref) => UIState());

// Active section provider (for sidebar navigation)
final activeSectionProvider = StateProvider<String>((ref) => 'profile');
