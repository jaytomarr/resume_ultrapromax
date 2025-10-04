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

/// Education section form
class EducationSection extends ConsumerStatefulWidget {
  const EducationSection({super.key});

  @override
  ConsumerState<EducationSection> createState() => _EducationSectionState();
}

class _EducationSectionState extends ConsumerState<EducationSection> {
  @override
  Widget build(BuildContext context) {
    final resumeData = ref.watch(resumeProvider);

    return SectionCard(
      title: AppConstants.sectionEducation,
      child: Column(
        children: [
          // Education entries
          ...resumeData.education.asMap().entries.map((entry) {
            final index = entry.key;
            final education = entry.value;
            final isLast = index == resumeData.education.length - 1;

            return Container(
              margin: EdgeInsets.only(
                bottom: isLast ? 0 : AppConstants.spacingMD,
              ),
              child: _EducationEntry(
                education: education,
                index: index,
                canRemove: resumeData.education.length > 1,
              ),
            );
          }),

          const SizedBox(height: AppConstants.spacingMD),

          // Add Education Button
          SizedBox(
            width: double.infinity,
            child: NotionButton(
              text: AppConstants.buttonAddEducation,
              icon: Icons.add,
              isSecondary: true,
              onPressed: () {
                ref.read(resumeProvider.notifier).addEducation();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EducationEntry extends ConsumerStatefulWidget {
  final Education education;
  final int index;
  final bool canRemove;

  const _EducationEntry({
    required this.education,
    required this.index,
    required this.canRemove,
  });

  @override
  ConsumerState<_EducationEntry> createState() => _EducationEntryState();
}

class _EducationEntryState extends ConsumerState<_EducationEntry> {
  final _universityController = TextEditingController();
  final _degreeController = TextEditingController();
  final _dateController = TextEditingController();
  final _cgpaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant _EducationEntry oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controllers when the widget's education data changes
    if (oldWidget.education.id != widget.education.id ||
        oldWidget.education.university != widget.education.university ||
        oldWidget.education.degree != widget.education.degree ||
        oldWidget.education.date != widget.education.date ||
        oldWidget.education.cgpa != widget.education.cgpa) {
      if (_universityController.text != widget.education.university) {
        _universityController.text = widget.education.university;
      }
      if (_degreeController.text != widget.education.degree) {
        _degreeController.text = widget.education.degree;
      }
      if (_dateController.text != widget.education.date) {
        _dateController.text = widget.education.date;
      }
      final cgpa = widget.education.cgpa ?? '';
      if (_cgpaController.text != cgpa) {
        _cgpaController.text = cgpa;
      }
    }
  }

  @override
  void dispose() {
    _universityController.dispose();
    _degreeController.dispose();
    _dateController.dispose();
    _cgpaController.dispose();
    super.dispose();
  }

  void _loadData() {
    _universityController.text = widget.education.university;
    _degreeController.text = widget.education.degree;
    _dateController.text = widget.education.date;
    _cgpaController.text = widget.education.cgpa ?? '';
  }

  void _updateEducation() {
    final updatedEducation = widget.education.copyWith(
      university: _universityController.text,
      degree: _degreeController.text,
      date: _dateController.text,
      cgpa: _cgpaController.text.isEmpty ? null : _cgpaController.text,
    );

    final educationList = ref.read(resumeProvider).education;
    final updatedList = List<Education>.from(educationList);
    updatedList[widget.index] = updatedEducation;

    ref.read(resumeProvider.notifier).updateEducation(updatedList);
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
                  'Education ${widget.index + 1}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              if (widget.canRemove)
                IconButton(
                  onPressed: () {
                    ref
                        .read(resumeProvider.notifier)
                        .removeEducation(widget.education.id);
                  },
                  icon: Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  padding: EdgeInsets.zero,
                ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingSM),

          // First Row - University and Date
          Row(
            children: [
              Expanded(
                flex: 2,
                child: NotionTextField(
                  label: AppConstants.labelUniversity,
                  controller: _universityController,
                  hintText: AppConstants.placeholderUniversity,
                  onChanged: (_) => _updateEducation(),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Expanded(
                flex: 1,
                child: NotionTextField(
                  label: AppConstants.labelDate,
                  controller: _dateController,
                  hintText: AppConstants.placeholderDate,
                  onChanged: (_) => _updateEducation(),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMD),

          // Second Row - Degree and CGPA
          Row(
            children: [
              Expanded(
                flex: 2,
                child: NotionTextField(
                  label: AppConstants.labelDegree,
                  controller: _degreeController,
                  hintText: AppConstants.placeholderDegree,
                  onChanged: (_) => _updateEducation(),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Expanded(
                flex: 1,
                child: NotionTextField(
                  label: AppConstants.labelCGPA,
                  controller: _cgpaController,
                  hintText: AppConstants.placeholderCGPA,
                  onChanged: (_) => _updateEducation(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
