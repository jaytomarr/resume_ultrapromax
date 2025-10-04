import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/mobile_restriction_dialog.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/builder/providers/resume_provider.dart'
    hide authServiceProvider;
import 'widgets/sidebar_menu.dart';
import 'widgets/action_bar.dart';
import 'widgets/sections/profile_section.dart';
import 'widgets/sections/education_section.dart';
import 'widgets/sections/experience_section.dart';
import 'widgets/sections/projects_section.dart';
import 'widgets/sections/skills_section.dart';
import 'widgets/sections/leadership_section.dart';
import 'widgets/sections/achievements_section.dart';

/// Main builder page with sidebar and form sections
class BuilderPage extends ConsumerStatefulWidget {
  const BuilderPage({super.key});

  @override
  ConsumerState<BuilderPage> createState() => _BuilderPageState();
}

class _BuilderPageState extends ConsumerState<BuilderPage> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};
  String? _errorMessage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeSectionKeys();
    _loadUserData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeSectionKeys() {
    _sectionKeys['profile'] = GlobalKey();
    _sectionKeys['education'] = GlobalKey();
    _sectionKeys['experience'] = GlobalKey();
    _sectionKeys['projects'] = GlobalKey();
    _sectionKeys['skills'] = GlobalKey();
    _sectionKeys['leadership'] = GlobalKey();
    _sectionKeys['achievements'] = GlobalKey();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _errorMessage = null;
    });

    try {
      await ref.read(resumeProvider.notifier).loadData();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data. Please check your connection.';
      });
    } finally {}
  }

  Future<void> _saveData() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await ref.read(resumeProvider.notifier).saveData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppConstants.messageSavedSuccessfully),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = AppConstants.errorSaveFailed;
      });
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _generatePreview() async {
    try {
      // Save data first
      await ref.read(resumeProvider.notifier).saveData();

      // Navigate to preview page
      if (mounted) {
        Navigator.of(context).pushNamed('/preview');
      }
    } catch (e) {
      setState(() {
        _errorMessage = AppConstants.errorSaveFailed;
      });
    }
  }

  void _scrollToSection(String sectionId) {
    final context = _sectionKeys[sectionId]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: AppConstants.scrollDuration,
        curve: Curves.easeOut,
        alignment: 0.1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    // Check if user is authenticated
    if (currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Check if mobile device
    if (ResponsiveUtils.isMobile(context)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => const MobileRestrictionDialog(),
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          Row(
            children: [
              // Left Sidebar
              Container(
                width: AppConstants.sidebarWidth,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.cardPink,
                  border: Border(
                    right: BorderSide(color: AppColors.textDark, width: 2),
                  ),
                ),
                child: SidebarMenu(
                  currentUser: currentUser,
                  onSectionTap: _scrollToSection,
                  onResetData: () async {
                    try {
                      await ref.read(resumeProvider.notifier).resetData();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppConstants.messageDataResetSuccessfully,
                            ),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    } catch (e) {
                      setState(() {
                        _errorMessage = AppConstants.errorResetFailed;
                      });
                    } finally {}
                  },
                  onLogout: () async {
                    try {
                      await ref.read(authServiceProvider).signOut();
                      if (mounted) {
                        Navigator.of(context).pushReplacementNamed('/');
                      }
                    } catch (e) {
                      setState(() {
                        _errorMessage = 'Failed to sign out. Please try again.';
                      });
                    } finally {}
                  },
                ),
              ),

              // Main Content Area
              Expanded(
                child: Column(
                  children: [
                    // Action Bar
                    ActionBar(
                      onSave: _saveData,
                      onGeneratePreview: _generatePreview,
                      isLoading: _isSaving,
                    ),

                    // Scrollable Form Content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(AppConstants.spacingLG),
                        child: Column(
                          children: [
                            // Profile Section (White Background)
                            Container(
                              key: _sectionKeys['profile'],
                              margin: const EdgeInsets.only(
                                bottom: AppConstants.spacingLG,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.cardWhite,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.symmetric(
                                  vertical: BorderSide(
                                    color: AppColors.textDark,
                                    width: 2,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textDark,
                                    offset: Offset(4, 4),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: const ProfileSection(),
                            ),

                            // Education Section (Yellow Background)
                            Container(
                              key: _sectionKeys['education'],
                              margin: const EdgeInsets.only(
                                bottom: AppConstants.spacingLG,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryYellow,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.symmetric(
                                  vertical: BorderSide(
                                    color: AppColors.textDark,
                                    width: 2,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textDark,
                                    offset: Offset(4, 4),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: const EducationSection(),
                            ),

                            // Experience Section (White Background)
                            Container(
                              key: _sectionKeys['experience'],
                              margin: const EdgeInsets.only(
                                bottom: AppConstants.spacingLG,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.cardWhite,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.symmetric(
                                  vertical: BorderSide(
                                    color: AppColors.textDark,
                                    width: 2,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textDark,
                                    offset: Offset(4, 4),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: const ExperienceSection(),
                            ),

                            // Projects Section (Yellow Background)
                            Container(
                              key: _sectionKeys['projects'],
                              margin: const EdgeInsets.only(
                                bottom: AppConstants.spacingLG,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryYellow,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.symmetric(
                                  vertical: BorderSide(
                                    color: AppColors.textDark,
                                    width: 2,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textDark,
                                    offset: Offset(4, 4),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: const ProjectsSection(),
                            ),

                            // Skills Section (White Background)
                            Container(
                              key: _sectionKeys['skills'],
                              margin: const EdgeInsets.only(
                                bottom: AppConstants.spacingLG,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.cardWhite,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.symmetric(
                                  vertical: BorderSide(
                                    color: AppColors.textDark,
                                    width: 2,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textDark,
                                    offset: Offset(4, 4),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: const SkillsSection(),
                            ),

                            // Leadership Section (Yellow Background)
                            Container(
                              key: _sectionKeys['leadership'],
                              margin: const EdgeInsets.only(
                                bottom: AppConstants.spacingLG,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryYellow,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.symmetric(
                                  vertical: BorderSide(
                                    color: AppColors.textDark,
                                    width: 2,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textDark,
                                    offset: Offset(4, 4),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: const LeadershipSection(),
                            ),

                            // Achievements Section (White Background)
                            Container(
                              key: _sectionKeys['achievements'],
                              margin: const EdgeInsets.only(
                                bottom: AppConstants.spacingLG,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.cardWhite,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.symmetric(
                                  vertical: BorderSide(
                                    color: AppColors.textDark,
                                    width: 2,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textDark,
                                    offset: Offset(4, 4),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: const AchievementsSection(),
                            ),

                            // Bottom spacing
                            const SizedBox(height: AppConstants.spacing3XL),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Loading Overlay only for explicit Save action
          if (_isSaving)
            LoadingOverlay(
              message: AppConstants.loadingSaving,
              isLoading: _isSaving,
            ),

          // Error Message
          if (_errorMessage != null)
            Positioned(
              top: 100,
              left: AppConstants.sidebarWidth + AppConstants.spacingLG,
              right: AppConstants.spacingLG,
              child: Container(
                padding: const EdgeInsets.all(AppConstants.spacingMD),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white, size: 20),
                    const SizedBox(width: AppConstants.spacingSM),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _errorMessage = null),
                      icon: Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
