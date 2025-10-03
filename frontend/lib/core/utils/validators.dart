/// Input validation utilities for form fields
class Validators {
  /// Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Phone number validation (basic)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 10) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Required field validation
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// URL validation
  static String? validateURL(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    // Relaxed acceptance: allow domain-like strings, paths, or full http(s) URLs
    final hasScheme =
        value.startsWith('http://') || value.startsWith('https://');
    final looksLikeDomain = RegExp(
      r"[a-zA-Z0-9-]+\.[a-zA-Z]{2,}",
    ).hasMatch(value);
    final looksLikePathOrHandle = value.startsWith('/') || value.contains('/');

    if (hasScheme || looksLikeDomain || looksLikePathOrHandle) {
      return null;
    }

    // Do not block entries without scheme; allow user-provided strings
    return null;
  }

  /// LinkedIn profile validation
  static String? validateLinkedIn(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    // Relaxed: accept full URLs, bare domains, or usernames
    if (value.startsWith('http')) {
      return validateURL(value, fieldName: 'LinkedIn URL');
    }

    final domainOrPathOk = RegExp(
      r"[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+(/.*)?$",
    ).hasMatch(value);
    final usernameOk = RegExp(r'^[a-zA-Z0-9.-]+$').hasMatch(value);
    if (domainOrPathOk || usernameOk) {
      return null;
    }

    return null;
  }

  /// GitHub profile validation
  static String? validateGitHub(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    // Relaxed: accept full URLs, bare domains, or usernames
    if (value.startsWith('http')) {
      return validateURL(value, fieldName: 'GitHub URL');
    }

    final domainOrPathOk = RegExp(
      r"[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+(/.*)?$",
    ).hasMatch(value);
    final usernameOk = RegExp(r'^[a-zA-Z0-9.-]+$').hasMatch(value);
    if (domainOrPathOk || usernameOk) {
      return null;
    }

    return null;
  }

  /// Text length validation
  static String? validateLength(
    String? value, {
    int? minLength,
    int? maxLength,
    String? fieldName,
  }) {
    if (value == null) return null;

    if (minLength != null && value.length < minLength) {
      return '${fieldName ?? 'Text'} must be at least $minLength characters';
    }

    if (maxLength != null && value.length > maxLength) {
      return '${fieldName ?? 'Text'} must be no more than $maxLength characters';
    }

    return null;
  }

  /// Validate that at least one item exists in a list
  static String? validateAtLeastOne(List<dynamic>? list, {String? fieldName}) {
    if (list == null || list.isEmpty) {
      return 'At least one ${fieldName ?? 'item'} is required';
    }

    // Check if all items are empty strings
    final hasNonEmptyItem = list.any((item) {
      if (item is String) {
        return item.trim().isNotEmpty;
      }
      return item != null;
    });

    if (!hasNonEmptyItem) {
      return 'At least one ${fieldName ?? 'item'} is required';
    }

    return null;
  }

  /// Validate that points are not empty
  static String? validatePoints(List<String>? points) {
    if (points == null || points.isEmpty) {
      return 'At least one point is required';
    }

    final hasNonEmptyPoint = points.any((point) => point.trim().isNotEmpty);
    if (!hasNonEmptyPoint) {
      return 'At least one point is required';
    }

    return null;
  }

  /// Validate achievements list
  static String? validateAchievements(List<String>? achievements) {
    if (achievements == null || achievements.isEmpty) {
      return null; // Achievements are optional
    }

    final hasNonEmptyAchievement = achievements.any(
      (achievement) => achievement.trim().isNotEmpty,
    );
    if (!hasNonEmptyAchievement) {
      return 'Please enter at least one achievement or remove the section';
    }

    return null;
  }

  /// Validate comma-separated skills
  static String? validateSkills(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    final skills = value
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (skills.isEmpty) {
      return 'Please enter at least one ${fieldName ?? 'skill'}';
    }

    return null;
  }

  /// Validate date format (basic)
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }

    // Basic date format validation (accepts various formats)
    final dateRegex = RegExp(r'^\d{4}.*\d{4}$|^\d{4}$|^[A-Za-z]+\s+\d{4}$');
    if (!dateRegex.hasMatch(value)) {
      return 'Please enter a valid date (e.g., 2021 - 2025)';
    }

    return null;
  }

  /// Validate CGPA/GPA format
  static String? validateCGPA(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    // Accept formats like "3.8/4.0", "CGPA: 7.76/10", "3.8"
    final cgpaRegex = RegExp(
      r'^[A-Za-z:\s]*\d+\.?\d*\s*/\s*\d+\.?\d*$|^\d+\.?\d*$',
    );
    if (!cgpaRegex.hasMatch(value)) {
      return 'Please enter a valid CGPA/GPA (e.g., CGPA: 7.76/10)';
    }

    return null;
  }
}
