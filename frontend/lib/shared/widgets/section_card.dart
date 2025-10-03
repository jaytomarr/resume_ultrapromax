import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import 'notion_card.dart';

/// Section card wrapper for form sections
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return NotionCard(
      padding: const EdgeInsets.all(AppConstants.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            title,
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
          ),

          const SizedBox(height: AppConstants.spacingLG),

          // Section Content
          child,
        ],
      ),
    );
  }
}
