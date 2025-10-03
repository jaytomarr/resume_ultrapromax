import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';

/// Top navigation bar for landing page
class TopNavbar extends StatelessWidget {
  const TopNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
        child: Row(
          children: [
            // App Logo/Name
            Text(
              AppConstants.appName,
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
            ),

            const Spacer(),

            // View Example Button (not clickable)
            OutlinedButton(
              onPressed: null, // Not clickable as per PRD
              child: Text(AppConstants.buttonViewExample),
            ),
          ],
        ),
      ),
    );
  }
}
