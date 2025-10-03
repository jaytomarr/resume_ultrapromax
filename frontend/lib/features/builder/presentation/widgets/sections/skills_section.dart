import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../shared/widgets/notion_text_field.dart';
import '../../../../../shared/widgets/section_card.dart';
import '../../../providers/resume_provider.dart';
import '../../../models/resume_data.dart';

/// Skills section form
class SkillsSection extends ConsumerStatefulWidget {
  const SkillsSection({super.key});

  @override
  ConsumerState<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends ConsumerState<SkillsSection> {
  final _languagesController = TextEditingController();
  final _technologiesController = TextEditingController();
  final _professionalController = TextEditingController();
  ProviderSubscription<ResumeData>? _resumeSubscription;

  @override
  void initState() {
    super.initState();
    _loadData();
    // React to async provider updates
    _resumeSubscription = ref.listenManual(resumeProvider, (previous, next) {
      final skills = next.skills;
      if (skills != null) {
        final languages = skills.languages ?? '';
        if (_languagesController.text != languages) {
          _languagesController.text = languages;
        }
        final technologies = skills.technologies ?? '';
        if (_technologiesController.text != technologies) {
          _technologiesController.text = technologies;
        }
        final professional = skills.professional ?? '';
        if (_professionalController.text != professional) {
          _professionalController.text = professional;
        }
      }
    });
  }

  @override
  void dispose() {
    _resumeSubscription?.close();
    _languagesController.dispose();
    _technologiesController.dispose();
    _professionalController.dispose();
    super.dispose();
  }

  void _loadData() {
    final skills = ref.read(resumeProvider).skills;
    if (skills != null) {
      _languagesController.text = skills.languages ?? '';
      _technologiesController.text = skills.technologies ?? '';
      _professionalController.text = skills.professional ?? '';
    }
  }

  void _updateSkills() {
    final updatedSkills = Skills(
      languages: _languagesController.text.isEmpty
          ? null
          : _languagesController.text,
      technologies: _technologiesController.text.isEmpty
          ? null
          : _technologiesController.text,
      professional: _professionalController.text.isEmpty
          ? null
          : _professionalController.text,
    );

    ref.read(resumeProvider.notifier).updateSkills(updatedSkills);
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: AppConstants.sectionSkills,
      child: Column(
        children: [
          // Programming Languages
          NotionTextField(
            label: AppConstants.labelLanguages,
            controller: _languagesController,
            hintText: AppConstants.placeholderLanguages,
            helperText: 'Comma-separated list',
            onChanged: (_) => _updateSkills(),
          ),

          const SizedBox(height: AppConstants.spacingMD),

          // Technologies & Tools
          NotionTextField(
            label: AppConstants.labelTechnologies,
            controller: _technologiesController,
            hintText: AppConstants.placeholderTechnologies,
            helperText: 'Comma-separated list',
            onChanged: (_) => _updateSkills(),
          ),

          const SizedBox(height: AppConstants.spacingMD),

          // Professional Skills
          NotionTextField(
            label: AppConstants.labelProfessionalSkills,
            controller: _professionalController,
            hintText: AppConstants.placeholderProfessionalSkills,
            helperText: 'Optional - Comma-separated list',
            onChanged: (_) => _updateSkills(),
          ),
        ],
      ),
    );
  }
}
