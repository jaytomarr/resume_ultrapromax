import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/notion_button.dart';
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
                CircleAvatar(
                  radius: AppConstants.avatarSize / 2,
                  backgroundColor: AppColors.primary,
                  backgroundImage: widget.currentUser.photoURL != null
                      ? NetworkImage(widget.currentUser.photoURL!)
                      : null,
                  child: widget.currentUser.photoURL == null
                      ? Text(
                          authService.userInitials,
                          style: AppTextStyles.h3.copyWith(color: Colors.white),
                        )
                      : null,
                ),

                const SizedBox(height: AppConstants.spacingSM),

                // User Name
                Text(
                  widget.currentUser.displayName ?? 'User',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
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
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.divider),

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
                  child: NotionButton(
                    text: AppConstants.buttonResetData,
                    icon: Icons.refresh,
                    isSecondary: true,
                    onPressed: _showResetConfirmation,
                  ),
                ),

                const SizedBox(height: AppConstants.spacingSM),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: NotionButton(
                    text: AppConstants.buttonLogout,
                    icon: Icons.logout,
                    isSecondary: true,
                    isDanger: true,
                    onPressed: _showLogoutConfirmation,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.divider),

          // Section Navigation Menu
          Expanded(
            child: ListView.builder(
              itemCount: _sections.length,
              itemBuilder: (context, index) {
                final section = _sections[index];
                final isActive = _activeSection == section['id'];

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  child: Material(
                    color: isActive
                        ? AppColors.sidebarActive
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _activeSection = section['id'];
                        });
                        widget.onSectionTap(section['id']);
                      },
                      borderRadius: BorderRadius.circular(4),
                      hoverColor: AppColors.sidebarHover,
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
                              color: isActive
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppConstants.spacingSM),
                            Expanded(
                              child: Text(
                                section['title'],
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isActive
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                  fontWeight: isActive
                                      ? FontWeight.w500
                                      : FontWeight.normal,
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
        ],
      ),
    );
  }
}
