import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/notion_button.dart';

/// Action bar with save and generate preview buttons
class ActionBar extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onGeneratePreview;
  final bool isLoading;

  const ActionBar({
    super.key,
    required this.onSave,
    required this.onGeneratePreview,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          const Spacer(),

          // Save Button
          NotionButton(
            text: AppConstants.buttonSave,
            icon: Icons.save,
            isSecondary: true,
            isLoading: isLoading,
            onPressed: isLoading ? null : onSave,
          ),

          const SizedBox(width: AppConstants.spacingSM),

          // Generate Preview Button
          NotionButton(
            text: AppConstants.buttonGeneratePreview,
            icon: Icons.visibility,
            isLoading: isLoading,
            onPressed: isLoading ? null : onGeneratePreview,
          ),
        ],
      ),
    );
  }
}
