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

/// Projects section form
class ProjectsSection extends ConsumerStatefulWidget {
  const ProjectsSection({super.key});

  @override
  ConsumerState<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends ConsumerState<ProjectsSection> {
  @override
  Widget build(BuildContext context) {
    final resumeData = ref.watch(resumeProvider);

    return SectionCard(
      title: AppConstants.sectionProjects,
      child: Column(
        children: [
          // Project entries
          ...resumeData.projects.asMap().entries.map((entry) {
            final index = entry.key;
            final project = entry.value;
            final isLast = index == resumeData.projects.length - 1;

            return Container(
              margin: EdgeInsets.only(
                bottom: isLast ? 0 : AppConstants.spacingMD,
              ),
              child: _ProjectEntry(project: project, index: index),
            );
          }),

          const SizedBox(height: AppConstants.spacingMD),

          // Add Project Button
          SizedBox(
            width: double.infinity,
            child: NotionButton(
              text: AppConstants.buttonAddProject,
              icon: Icons.add,
              isSecondary: true,
              onPressed: () {
                ref.read(resumeProvider.notifier).addProject();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectEntry extends ConsumerStatefulWidget {
  final Project project;
  final int index;

  const _ProjectEntry({required this.project, required this.index});

  @override
  ConsumerState<_ProjectEntry> createState() => _ProjectEntryState();
}

class _ProjectEntryState extends ConsumerState<_ProjectEntry> {
  final _nameController = TextEditingController();
  final _linkController = TextEditingController();
  final List<TextEditingController> _pointControllers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _linkController.dispose();
    for (final controller in _pointControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _loadData() {
    _nameController.text = widget.project.name;
    _linkController.text = widget.project.link ?? '';

    // Clear existing controllers
    for (final controller in _pointControllers) {
      controller.dispose();
    }
    _pointControllers.clear();

    // Create controllers for points
    for (final point in widget.project.points) {
      final controller = TextEditingController(text: point);
      controller.addListener(_updateProject);
      _pointControllers.add(controller);
    }
  }

  void _updateProject() {
    final points = _pointControllers.map((c) => c.text).toList();
    final updatedProject = widget.project.copyWith(
      name: _nameController.text,
      link: _linkController.text.isEmpty ? null : _linkController.text,
      points: points,
    );

    final projectList = ref.read(resumeProvider).projects;
    final updatedList = List<Project>.from(projectList);
    updatedList[widget.index] = updatedProject;

    ref.read(resumeProvider.notifier).updateProjects(updatedList);
  }

  void _addPoint() {
    final controller = TextEditingController();
    controller.addListener(_updateProject);
    _pointControllers.add(controller);
    ref.read(resumeProvider.notifier).addProjectPoint(widget.project.id);
  }

  void _removePoint(int pointIndex) {
    if (_pointControllers.length > 1) {
      _pointControllers[pointIndex].dispose();
      _pointControllers.removeAt(pointIndex);
      ref
          .read(resumeProvider.notifier)
          .removeProjectPoint(widget.project.id, pointIndex);
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
                  'Project ${widget.index + 1}',
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
                      .removeProject(widget.project.id);
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

          // Project Name and Link in Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: NotionTextField(
                  label: AppConstants.labelProjectName,
                  controller: _nameController,
                  hintText: AppConstants.placeholderProjectName,
                  onChanged: (_) => _updateProject(),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Expanded(
                flex: 1,
                child: NotionTextField(
                  label: AppConstants.labelProjectLink,
                  controller: _linkController,
                  hintText: AppConstants.placeholderProjectLink,
                  onChanged: (_) => _updateProject(),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMD),

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
