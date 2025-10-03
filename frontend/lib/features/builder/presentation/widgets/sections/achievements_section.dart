import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/notion_text_field.dart';
import '../../../../../shared/widgets/notion_button.dart';
import '../../../../../shared/widgets/section_card.dart';
import '../../../providers/resume_provider.dart';

/// Achievements section form
class AchievementsSection extends ConsumerWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumeData = ref.watch(resumeProvider);

    return SectionCard(
      title: AppConstants.sectionAchievements,
      child: Column(
        children: [
          // Achievement entries
          ...resumeData.achievements.asMap().entries.map((entry) {
            final index = entry.key;
            final achievement = entry.value;
            final isFirst = index == 0;

            return Container(
              margin: const EdgeInsets.only(bottom: AppConstants.spacingSM),
              child: Row(
                children: [
                  Expanded(
                    child: NotionTextField(
                      initialValue: achievement,
                      hintText: AppConstants.placeholderAchievement,
                      onChanged: (value) =>
                          _updateAchievement(ref, index, value),
                    ),
                  ),
                  if (!isFirst) ...[
                    const SizedBox(width: AppConstants.spacingSM),
                    IconButton(
                      onPressed: () => _removeAchievement(ref, index),
                      icon: Icon(
                        Icons.remove_circle_outline,
                        size: 20,
                        color: AppColors.error,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ],
              ),
            );
          }),

          const SizedBox(height: AppConstants.spacingMD),

          // Add Achievement Button
          SizedBox(
            width: double.infinity,
            child: NotionButton(
              text: AppConstants.buttonAddAchievement,
              icon: Icons.add,
              isSecondary: true,
              onPressed: () => _addAchievement(ref),
            ),
          ),
        ],
      ),
    );
  }

  void _updateAchievement(WidgetRef ref, int index, String value) {
    final achievements = List<String>.from(
      ref.read(resumeProvider).achievements,
    );
    if (index < achievements.length) {
      achievements[index] = value;
      ref.read(resumeProvider.notifier).updateAchievements(achievements);
    }
  }

  void _addAchievement(WidgetRef ref) {
    ref.read(resumeProvider.notifier).addAchievement();
  }

  void _removeAchievement(WidgetRef ref, int index) {
    ref.read(resumeProvider.notifier).removeAchievement(index);
  }
}
