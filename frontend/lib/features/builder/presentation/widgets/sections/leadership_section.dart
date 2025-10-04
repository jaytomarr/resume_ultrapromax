import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../shared/widgets/notion_text_field.dart';
import '../../../../../shared/widgets/notion_button.dart';
import '../../../../../shared/widgets/section_card.dart';
import '../../../providers/resume_provider.dart';
import '../../../models/resume_data.dart';

/// Leadership section form
class LeadershipSection extends ConsumerStatefulWidget {
  const LeadershipSection({super.key});

  @override
  ConsumerState<LeadershipSection> createState() => _LeadershipSectionState();
}

class _LeadershipSectionState extends ConsumerState<LeadershipSection> {
  @override
  Widget build(BuildContext context) {
    final resumeData = ref.watch(resumeProvider);

    return SectionCard(
      title: AppConstants.sectionLeadership,
      child: Column(
        children: [
          // Leadership entries
          ...resumeData.leadership.asMap().entries.map((entry) {
            final index = entry.key;
            final leadership = entry.value;
            final isLast = index == resumeData.leadership.length - 1;

            return Container(
              margin: EdgeInsets.only(
                bottom: isLast ? 0 : AppConstants.spacingMD,
              ),
              child: _LeadershipEntry(leadership: leadership, index: index),
            );
          }),

          const SizedBox(height: AppConstants.spacingMD),

          // Add Leadership Button
          SizedBox(
            width: double.infinity,
            child: NotionButton(
              text: AppConstants.buttonAddLeadership,
              icon: Icons.add,
              isSecondary: true,
              onPressed: () {
                ref.read(resumeProvider.notifier).addLeadership();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LeadershipEntry extends ConsumerStatefulWidget {
  final Leadership leadership;
  final int index;

  const _LeadershipEntry({required this.leadership, required this.index});

  @override
  ConsumerState<_LeadershipEntry> createState() => _LeadershipEntryState();
}

class _LeadershipEntryState extends ConsumerState<_LeadershipEntry> {
  final _organizationController = TextEditingController();
  final _roleController = TextEditingController();
  final _dateController = TextEditingController();
  final List<TextEditingController> _pointControllers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _organizationController.dispose();
    _roleController.dispose();
    _dateController.dispose();
    for (final controller in _pointControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _loadData() {
    _organizationController.text = widget.leadership.organization;
    _roleController.text = widget.leadership.role;
    _dateController.text = widget.leadership.date;

    // Clear existing controllers
    for (final controller in _pointControllers) {
      controller.dispose();
    }
    _pointControllers.clear();

    // Create controllers for points
    for (final point in widget.leadership.points) {
      final controller = TextEditingController(text: point);
      controller.addListener(_updateLeadership);
      _pointControllers.add(controller);
    }
  }

  void _updateLeadership() {
    final points = _pointControllers.map((c) => c.text).toList();
    final updatedLeadership = widget.leadership.copyWith(
      organization: _organizationController.text,
      role: _roleController.text,
      date: _dateController.text,
      points: points,
    );

    final leadershipList = ref.read(resumeProvider).leadership;
    final updatedList = List<Leadership>.from(leadershipList);
    updatedList[widget.index] = updatedLeadership;

    ref.read(resumeProvider.notifier).updateLeadership(updatedList);
  }

  void _addPoint() {
    final controller = TextEditingController();
    controller.addListener(_updateLeadership);
    _pointControllers.add(controller);
    ref.read(resumeProvider.notifier).addLeadershipPoint(widget.leadership.id);
  }

  void _removePoint(int pointIndex) {
    if (_pointControllers.length > 1) {
      _pointControllers[pointIndex].dispose();
      _pointControllers.removeAt(pointIndex);
      ref
          .read(resumeProvider.notifier)
          .removeLeadershipPoint(widget.leadership.id, pointIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMD),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with remove button
          Row(
            children: [
              Expanded(
                child: Text(
                  'Leadership Role ${widget.index + 1}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  ref
                      .read(resumeProvider.notifier)
                      .removeLeadership(widget.leadership.id);
                },
                icon: Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                padding: EdgeInsets.zero,
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMD),

          // Organization
          NotionTextField(
            label: AppConstants.labelOrganization,
            controller: _organizationController,
            hintText: AppConstants.placeholderOrganization,
            onChanged: (_) => _updateLeadership(),
          ),

          const SizedBox(height: AppConstants.spacingMD),

          // Role/Position
          NotionTextField(
            label: AppConstants.labelRole,
            controller: _roleController,
            hintText: AppConstants.placeholderRole,
            onChanged: (_) => _updateLeadership(),
          ),

          const SizedBox(height: AppConstants.spacingMD),

          // Date/Duration
          NotionTextField(
            label: AppConstants.labelDate,
            controller: _dateController,
            hintText: AppConstants.placeholderDate,
            onChanged: (_) => _updateLeadership(),
          ),

          const SizedBox(height: AppConstants.spacingMD),

          // Points
          Text(
            'Key Points:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: AppConstants.spacingSM),

          ..._pointControllers.asMap().entries.map((entry) {
            final pointIndex = entry.key;
            final controller = entry.value;
            final isFirst = pointIndex == 0;

            return Container(
              margin: const EdgeInsets.only(bottom: AppConstants.spacingSM),
              child: Row(
                children: [
                  Expanded(
                    child: NotionTextField(
                      controller: controller,
                      hintText: AppConstants.placeholderPoint,
                      maxLines: 2,
                    ),
                  ),
                  if (!isFirst) ...[
                    const SizedBox(width: AppConstants.spacingSM),
                    IconButton(
                      onPressed: () => _removePoint(pointIndex),
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

          // Add Point Button
          SizedBox(
            width: double.infinity,
            child: NotionButton(
              text: AppConstants.buttonAddPoint,
              icon: Icons.add,
              isSecondary: true,
              onPressed: _addPoint,
            ),
          ),
        ],
      ),
    );
  }
}
