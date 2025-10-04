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

/// Experience section form
class ExperienceSection extends ConsumerStatefulWidget {
  const ExperienceSection({super.key});

  @override
  ConsumerState<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends ConsumerState<ExperienceSection> {
  @override
  Widget build(BuildContext context) {
    final resumeData = ref.watch(resumeProvider);

    return SectionCard(
      title: AppConstants.sectionExperience,
      child: Column(
        children: [
          // Experience entries
          ...resumeData.experience.asMap().entries.map((entry) {
            final index = entry.key;
            final experience = entry.value;
            final isLast = index == resumeData.experience.length - 1;

            return Container(
              margin: EdgeInsets.only(
                bottom: isLast ? 0 : AppConstants.spacingMD,
              ),
              child: _ExperienceEntry(experience: experience, index: index),
            );
          }),

          const SizedBox(height: AppConstants.spacingMD),

          // Add Experience Button
          SizedBox(
            width: double.infinity,
            child: NotionButton(
              text: AppConstants.buttonAddExperience,
              icon: Icons.add,
              isSecondary: true,
              onPressed: () {
                ref.read(resumeProvider.notifier).addExperience();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceEntry extends ConsumerStatefulWidget {
  final Experience experience;
  final int index;

  const _ExperienceEntry({required this.experience, required this.index});

  @override
  ConsumerState<_ExperienceEntry> createState() => _ExperienceEntryState();
}

class _ExperienceEntryState extends ConsumerState<_ExperienceEntry> {
  final _companyController = TextEditingController();
  final _roleController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final List<TextEditingController> _pointControllers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    for (final controller in _pointControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _loadData() {
    _companyController.text = widget.experience.company;
    _roleController.text = widget.experience.role;
    _locationController.text = widget.experience.location;
    _dateController.text = widget.experience.date;

    // Clear existing controllers
    for (final controller in _pointControllers) {
      controller.dispose();
    }
    _pointControllers.clear();

    // Create controllers for points
    for (final point in widget.experience.points) {
      final controller = TextEditingController(text: point);
      controller.addListener(_updateExperience);
      _pointControllers.add(controller);
    }
  }

  void _updateExperience() {
    final points = _pointControllers.map((c) => c.text).toList();
    final updatedExperience = widget.experience.copyWith(
      company: _companyController.text,
      role: _roleController.text,
      location: _locationController.text,
      date: _dateController.text,
      points: points,
    );

    final experienceList = ref.read(resumeProvider).experience;
    final updatedList = List<Experience>.from(experienceList);
    updatedList[widget.index] = updatedExperience;

    ref.read(resumeProvider.notifier).updateExperience(updatedList);
  }

  void _addPoint() {
    final controller = TextEditingController();
    controller.addListener(_updateExperience);
    _pointControllers.add(controller);
    ref.read(resumeProvider.notifier).addExperiencePoint(widget.experience.id);
  }

  void _removePoint(int pointIndex) {
    if (_pointControllers.length > 1) {
      _pointControllers[pointIndex].dispose();
      _pointControllers.removeAt(pointIndex);
      ref
          .read(resumeProvider.notifier)
          .removeExperiencePoint(widget.experience.id, pointIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingSM),
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
                  'Experience ${widget.index + 1}',
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
                      .removeExperience(widget.experience.id);
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

          const SizedBox(height: AppConstants.spacingSM),

          // First Row - Company and Location
          Row(
            children: [
              Expanded(
                flex: 2,
                child: NotionTextField(
                  label: AppConstants.labelCompany,
                  controller: _companyController,
                  hintText: AppConstants.placeholderCompany,
                  onChanged: (_) => _updateExperience(),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Expanded(
                flex: 1,
                child: NotionTextField(
                  label: AppConstants.labelLocation,
                  controller: _locationController,
                  hintText: AppConstants.placeholderLocation,
                  onChanged: (_) => _updateExperience(),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMD),

          // Second Row - Role and Date
          Row(
            children: [
              Expanded(
                flex: 2,
                child: NotionTextField(
                  label: AppConstants.labelRole,
                  controller: _roleController,
                  hintText: AppConstants.placeholderRole,
                  onChanged: (_) => _updateExperience(),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Expanded(
                flex: 1,
                child: NotionTextField(
                  label: AppConstants.labelDate,
                  controller: _dateController,
                  hintText: AppConstants.placeholderDate,
                  onChanged: (_) => _updateExperience(),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingSM),

          // Points
          Text(
            'Key Points:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 8),

          ..._pointControllers.asMap().entries.map((entry) {
            final pointIndex = entry.key;
            final controller = entry.value;
            final isFirst = pointIndex == 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
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
