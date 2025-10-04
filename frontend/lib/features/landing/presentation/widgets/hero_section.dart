import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/widgets/google_sign_in_dialog.dart';
import '../../../../../shared/widgets/mobile_restriction_dialog.dart';

/// Hero section for the landing page
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.primaryPink),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determine if mobile or desktop
            bool isMobile = constraints.maxWidth < 768;

            return Container(
              width: isMobile
                  ? constraints.maxWidth * 0.95
                  : constraints.maxWidth * 0.8,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 40,
                vertical: isMobile ? 32 : 24,
              ),
              child: Column(
                mainAxisAlignment: isMobile
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Centered Content
                  Text(
                    AppConstants.appName,
                    style: AppTextStyles.heroTitle.copyWith(
                      fontSize: isMobile ? 38 : 48,
                      color: AppColors.textWhite,
                      fontWeight: isMobile ? FontWeight.w700 : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isMobile ? 16 : 20),
                  Text(
                    'Build your professional resume in minutes.',
                    style: AppTextStyles.tagline.copyWith(
                      fontSize: isMobile ? 20 : 20,
                      color: AppColors.textWhite,
                      fontWeight: isMobile ? FontWeight.w500 : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                  Text(
                    'Simple, clean, and ready-to-download resumes built instantly.',
                    style: AppTextStyles.bodyText.copyWith(
                      fontSize: isMobile ? 16 : 16,
                      color: AppColors.textWhite,
                      fontWeight: isMobile ? FontWeight.w400 : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isMobile ? 20 : 28),
                  ElevatedButton(
                    onPressed: () {
                      if (isMobile) {
                        showDialog(
                          context: context,
                          builder: (context) => const MobileRestrictionDialog(),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => const GoogleSignInDialog(),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentOrange,
                      foregroundColor: AppColors.textDark,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: AppColors.textDark,
                          width: 2,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 20 : 32,
                        vertical: isMobile ? 12 : 16,
                      ),
                      textStyle: TextStyle(
                        fontSize: isMobile ? 15 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(AppConstants.buttonGetStarted),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
