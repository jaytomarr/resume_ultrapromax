/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'Resume UltraProMax';
  static const String appVersion = '1.0.0';

  // UI Constants
  static const double cardPadding = 20.0;
  static const double sectionSpacing = 24.0;
  static const double buttonHeight = 36.0;
  static const double inputHeight = 36.0;
  static const double avatarSize = 48.0;
  static const double sidebarWidth = 240.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 100);
  static const Duration animationNormal = Duration(milliseconds: 200);
  static const Duration animationSlow = Duration(milliseconds: 350);
  static const Duration scrollDuration = Duration(milliseconds: 500);

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacing2XL = 48.0;
  static const double spacing3XL = 64.0;

  // Button Text
  static const String buttonGetStarted = 'Get Started';
  static const String buttonViewExample = 'View Example';
  static const String buttonSignInWithGoogle = 'Sign in with Google';
  static const String buttonSave = 'Save';
  static const String buttonGeneratePreview = 'Generate Preview';
  static const String buttonDownloadPDF = 'Download PDF';
  static const String buttonBackToEditor = 'Back to Editor';
  static const String buttonResetData = 'Reset Data';
  static const String buttonLogout = 'Logout';
  static const String buttonGotIt = 'Got it';
  static const String buttonCancel = 'Cancel';
  static const String buttonRetry = 'Retry';
  static const String buttonAddEducation = 'Add Education';
  static const String buttonAddExperience = 'Add Experience';
  static const String buttonAddProject = 'Add Project';
  static const String buttonAddLeadership = 'Add Leadership Role';
  static const String buttonAddAchievement = 'Add Achievement';
  static const String buttonAddPoint = 'Add Point';

  // Dialog Messages
  static const String dialogMobileTitle = 'Desktop or Tablet Required';
  static const String dialogMobileMessage =
      'Creating a resume requires a larger screen for the best experience. Please use a desktop or tablet device to access the resume builder.';
  static const String dialogResetTitle = 'Reset All Data?';
  static const String dialogResetMessage =
      'This will permanently delete all your resume data from cloud storage. This action cannot be undone.';
  static const String dialogLogoutTitle = 'Sign Out?';
  static const String dialogLogoutMessage =
      'Make sure you\'ve saved your work before signing out.';

  // Success Messages
  static const String messageSavedSuccessfully = 'Saved successfully';
  static const String messageDataLoaded = 'Data loaded';
  static const String messageDataResetSuccessfully = 'Data reset successfully';
  static const String messageSignedOutSuccessfully = 'Signed out successfully';
  static const String messagePDFDownloadedSuccessfully =
      'PDF downloaded successfully';

  // Error Messages
  static const String errorFillRequiredFields =
      'Please fill all required fields';
  static const String errorSaveFailed = 'Failed to save. Please try again.';
  static const String errorLoadFailed =
      'Failed to load data. Please check your connection.';
  static const String errorResetFailed =
      'Failed to reset data. Please try again.';
  static const String errorAuthFailed =
      'Authentication failed. Please try again later.';
  static const String errorNetworkConnection =
      'No internet connection. Please try again.';
  static const String errorPDFGenerationFailed =
      'Failed to generate PDF. Please try again.';

  // Loading Messages
  static const String loadingSaving = 'Saving...';
  static const String loadingLoading = 'Loading...';
  static const String loadingGenerating = 'Generating your resume...';
  static const String loadingSigningIn = 'Signing in...';
  static const String loadingResetting = 'Resetting...';

  // Section Names
  static const String sectionProfile = 'Profile';
  static const String sectionEducation = 'Education';
  static const String sectionExperience = 'Experience';
  static const String sectionProjects = 'Projects';
  static const String sectionSkills = 'Skills';
  static const String sectionLeadership = 'Leadership & Activities';
  static const String sectionAchievements = 'Achievements & Certifications';

  // Field Labels
  static const String labelFullName = 'Full Name';
  static const String labelPhone = 'Phone';
  static const String labelEmail = 'Email';
  static const String labelLinkedIn = 'LinkedIn URL';
  static const String labelGitHub = 'GitHub URL';
  static const String labelWebsite = 'Website URL';
  static const String labelSummary = 'Professional Summary';
  static const String labelUniversity = 'University/Institution';
  static const String labelDegree = 'Degree/Program';
  static const String labelDate = 'Date/Duration';
  static const String labelCGPA = 'CGPA/GPA';
  static const String labelCompany = 'Company';
  static const String labelRole = 'Role/Position';
  static const String labelLocation = 'Location';
  static const String labelProjectName = 'Project Name';
  static const String labelProjectLink = 'Project Link';
  static const String labelOrganization = 'Organization';
  static const String labelLanguages = 'Programming Languages';
  static const String labelTechnologies = 'Technologies & Tools';
  static const String labelProfessionalSkills = 'Professional Skills';

  // Placeholders
  static const String placeholderName = 'Enter your full name';
  static const String placeholderPhone = 'Enter your phone number';
  static const String placeholderEmail = 'Enter your email address';
  static const String placeholderLinkedIn = 'linkedin.com/in/yourusername';
  static const String placeholderGitHub = 'github.com/yourusername';
  static const String placeholderWebsite = 'yourwebsite.com';
  static const String placeholderSummary =
      'Brief summary of your professional background...';
  static const String placeholderUniversity =
      'Enter university/institution name';
  static const String placeholderDegree = 'Enter degree/program name';
  static const String placeholderDate = 'e.g., 2021 - 2025';
  static const String placeholderCGPA = 'e.g., CGPA: 7.76/10';
  static const String placeholderCompany = 'Enter company name';
  static const String placeholderRole = 'Enter your role/position';
  static const String placeholderLocation = 'e.g., San Francisco, CA';
  static const String placeholderProjectName = 'Enter project name';
  static const String placeholderProjectLink =
      'https://github.com/username/project';
  static const String placeholderOrganization = 'Enter organization name';
  static const String placeholderLanguages =
      'e.g., Dart, Python, Java, JavaScript';
  static const String placeholderTechnologies =
      'e.g., Flutter, Firebase, AWS, React';
  static const String placeholderProfessionalSkills =
      'e.g., Leadership, Communication, Project Management';
  static const String placeholderAchievement =
      'Enter achievement or certification';
  static const String placeholderPoint =
      'Describe your accomplishment or responsibility...';

  // Validation Messages
  static const String validationRequired = 'This field is required';
  static const String validationEmail = 'Please enter a valid email address';
  static const String validationPhone = 'Please enter a valid phone number';
  static const String validationURL = 'Please enter a valid URL';
  static const String validationLinkedIn =
      'Please enter a valid LinkedIn profile URL or username';
  static const String validationGitHub =
      'Please enter a valid GitHub profile URL or username';
  static const String validationMinLength =
      'Text must be at least {min} characters';
  static const String validationMaxLength =
      'Text must be no more than {max} characters';
  static const String validationAtLeastOnePoint =
      'At least one point is required';
  static const String validationAtLeastOneAchievement =
      'Please enter at least one achievement or remove the section';

  // File Names
  static const String fileNameResume = 'Resume_{name}_{date}.pdf';

  // API Endpoints
  static const String apiGeneratePDF = '/api/generate-resume';
  static const String apiHealth = '/api/health';
}
