import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/widgets/google_sign_in_dialog.dart';

/// Hero section for landing page
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing3XL),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main Heading
            Text(
              'Build your professional resume in minutes.',
              style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.spacingLG),

            // Subtext
            Text(
              'Simple, clean, and ready-to-download resumes built instantly.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.spacing2XL),

            // CTA Button
            ElevatedButton(
              onPressed: () {
                // Show Google Sign-In dialog
                showDialog(
                  context: context,
                  builder: (context) => const GoogleSignInDialog(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingXL,
                  vertical: AppConstants.spacingMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(AppConstants.buttonGetStarted),
            ),
          ],
        ),
      ),
    );
  }
}
