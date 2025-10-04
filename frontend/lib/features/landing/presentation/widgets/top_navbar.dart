import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';

/// Top navigation bar for landing page
class TopNavbar extends StatelessWidget {
  const TopNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 768;

        return Container(
          height: isMobile ? 50 : 60,
          color: AppColors.bgDark,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // App Logo/Name
              Row(
                children: [
                  Container(
                    width: isMobile ? 28 : 40,
                    height: isMobile ? 28 : 40,
                    margin: EdgeInsets.only(
                      right: isMobile ? 6 : AppConstants.spacingSM,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/icon.png',
                        width: isMobile ? 28 : 40,
                        height: isMobile ? 28 : 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Text(
                    AppConstants.appName,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textWhite,
                      fontSize: isMobile ? 14 : null,
                      fontWeight: isMobile ? FontWeight.w600 : null,
                    ),
                  ),
                ],
              ),
              // View Example Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/example');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryYellow,
                  foregroundColor: AppColors.textDark,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppColors.textDark, width: 2),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 32,
                    vertical: isMobile ? 6 : 16,
                  ),
                ),
                child: Text(
                  AppConstants.buttonViewExample,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : null,
                    fontWeight: isMobile ? FontWeight.w500 : null,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
