import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/error_dialog.dart';
import '../../../auth/providers/auth_provider.dart';

/// Sidebar menu with profile avatar, actions, and navigation
class SidebarMenu extends ConsumerStatefulWidget {
  final User currentUser;
  final Function(String) onSectionTap;
  final VoidCallback onResetData;
  final VoidCallback onLogout;

  const SidebarMenu({
    super.key,
    required this.currentUser,
    required this.onSectionTap,
    required this.onResetData,
    required this.onLogout,
  });

  @override
  ConsumerState<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends ConsumerState<SidebarMenu> {
  String _activeSection = 'profile';

  final List<Map<String, dynamic>> _sections = [
    {'id': 'profile', 'title': 'Profile', 'icon': Icons.person},
    {'id': 'education', 'title': 'Education', 'icon': Icons.school},
    {'id': 'experience', 'title': 'Experience', 'icon': Icons.work},
    {'id': 'projects', 'title': 'Projects', 'icon': Icons.rocket_launch},
    {'id': 'skills', 'title': 'Skills', 'icon': Icons.psychology},
    {'id': 'leadership', 'title': 'Leadership', 'icon': Icons.groups},
    {'id': 'achievements', 'title': 'Achievements', 'icon': Icons.emoji_events},
  ];

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: AppConstants.dialogResetTitle,
        message: AppConstants.dialogResetMessage,
        primaryButtonText: AppConstants.buttonResetData,
        secondaryButtonText: AppConstants.buttonCancel,
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          widget.onResetData();
        },
        onSecondaryPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: AppConstants.dialogLogoutTitle,
        message: AppConstants.dialogLogoutMessage,
        primaryButtonText: AppConstants.buttonLogout,
        secondaryButtonText: AppConstants.buttonCancel,
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          widget.onLogout();
        },
        onSecondaryPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMD),
      child: Column(
        children: [
          // Profile Avatar Section
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMD),
            child: Column(
              children: [
                // Avatar
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(
                      AppConstants.avatarSize / 2,
                    ),
                    border: Border.all(color: AppColors.textDark, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.textDark,
                        offset: Offset(2, 2),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: (AppConstants.avatarSize / 2) - 2,
                    backgroundColor: AppColors.accentOrange,
                    backgroundImage: widget.currentUser.photoURL != null
                        ? NetworkImage(widget.currentUser.photoURL!)
                        : null,
                    child: widget.currentUser.photoURL == null
                        ? Text(
                            authService.userInitials,
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: AppConstants.spacingSM),

                // User Name
                Text(
                  widget.currentUser.displayName ?? 'User',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppConstants.spacingXS),

                // User Email
                Text(
                  widget.currentUser.email ?? '',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          Divider(color: AppColors.textDark, thickness: 1, height: 1),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.spacingSM,
            ),
            child: Column(
              children: [
                // Reset Data Button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.textDark, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.textDark,
                          offset: Offset(2, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _showResetConfirmation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cardWhite,
                        foregroundColor: AppColors.textDark,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            AppConstants.buttonResetData,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingSM),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.textDark, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.textDark,
                          offset: Offset(2, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _showLogoutConfirmation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            AppConstants.buttonLogout,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(color: AppColors.textDark, thickness: 1, height: 1),

          // Section Navigation Menu
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _sections.length,
                    itemBuilder: (context, index) {
                      final section = _sections[index];
                      final isActive = _activeSection == section['id'];

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.cardWhite
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.textDark,
                            width: isActive ? 2 : 1,
                          ),
                          boxShadow: isActive
                              ? const [
                                  BoxShadow(
                                    color: AppColors.textDark,
                                    offset: Offset(1, 1),
                                    blurRadius: 0,
                                  ),
                                ]
                              : null,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _activeSection = section['id'];
                              });
                              widget.onSectionTap(section['id']);
                            },
                            borderRadius: BorderRadius.circular(8),
                            hoverColor: AppColors.cardWhite.withOpacity(0.5),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.spacingSM,
                                vertical: AppConstants.spacingSM,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    section['icon'],
                                    size: 18,
                                    color: AppColors.textDark,
                                  ),
                                  const SizedBox(width: AppConstants.spacingSM),
                                  Expanded(
                                    child: Text(
                                      section['title'],
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textDark,
                                        fontWeight: isActive
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Logo at bottom of sidebar
                Container(
                  margin: const EdgeInsets.only(top: AppConstants.spacingMD),
                  padding: const EdgeInsets.all(AppConstants.spacingSM),
                  child: Column(
                    children: [
                      Divider(
                        color: AppColors.textDark,
                        thickness: 1,
                        height: 1,
                      ),
                      const SizedBox(height: AppConstants.spacingSM),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icon.png',
                              width: 28,
                              height: 28,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                AppConstants.appName,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
