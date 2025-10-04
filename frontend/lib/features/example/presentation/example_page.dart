import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

/// Example page displaying a resume image with simple styling
class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      body: Column(
        children: [
          // Top Action Bar - Simple
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLG,
            ),
            decoration: const BoxDecoration(
              color: AppColors.bgDark,
              border: Border(
                bottom: BorderSide(color: AppColors.textDark, width: 2),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textDark,
                  offset: Offset(0, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                // Back Button
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryYellow,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, size: 18),
                      SizedBox(width: 8),
                      Text('Back'),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),

          // Resume Image Area - Single Container
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: kIsWeb
                      ? 800
                      : double.infinity, // 800px on web, full width on mobile
                  margin: EdgeInsets.all(
                    kIsWeb ? AppConstants.spacingLG : AppConstants.spacingSM,
                  ), // Less margin on mobile
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.textDark, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.textDark,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/resume.jpg',
                      fit: BoxFit
                          .fitWidth, // Changed to fitWidth to remove top/bottom space
                      width: double.infinity,
                      height: null, // Let image use its natural height
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: AppColors.error,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Image not found',
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'resume.jpg not found in assets folder',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
