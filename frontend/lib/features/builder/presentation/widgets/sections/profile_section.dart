import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../shared/widgets/notion_text_field.dart';
import '../../../../../shared/widgets/section_card.dart';
import '../../../../../features/auth/providers/auth_provider.dart';
import '../../../providers/resume_provider.dart';
import '../../../models/resume_data.dart';

/// Profile section form
class ProfileSection extends ConsumerStatefulWidget {
  const ProfileSection({super.key});

  @override
  ConsumerState<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends ConsumerState<ProfileSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _githubController = TextEditingController();
  final _websiteController = TextEditingController();
  final _summaryController = TextEditingController();
  ProviderSubscription<ResumeData>? _resumeSubscription;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Listen for async resume data load and update controllers reactively
    _resumeSubscription = ref.listenManual(resumeProvider, (previous, next) {
      final profile = next.profile;
      if (profile != null) {
        // Only update if values actually differ to avoid unnecessary rebuild loops
        if (_nameController.text != profile.name) {
          _nameController.text = profile.name;
        }
        if (_phoneController.text != profile.phone) {
          _phoneController.text = profile.phone;
        }
        if (_emailController.text != profile.email) {
          _emailController.text = profile.email;
        }
        final linkedin = profile.linkedin ?? '';
        if (_linkedinController.text != linkedin) {
          _linkedinController.text = linkedin;
        }
        final github = profile.github ?? '';
        if (_githubController.text != github) {
          _githubController.text = github;
        }
        final website = profile.website ?? '';
        if (_websiteController.text != website) {
          _websiteController.text = website;
        }
        final summary = profile.summary ?? '';
        if (_summaryController.text != summary) {
          _summaryController.text = summary;
        }
      }
    });
  }

  @override
  void dispose() {
    _resumeSubscription?.close();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _websiteController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  void _loadData() {
    final resumeData = ref.read(resumeProvider);
    final currentUser = ref.read(currentUserProvider);

    if (resumeData.profile != null) {
      _nameController.text = resumeData.profile!.name;
      _phoneController.text = resumeData.profile!.phone;
      _emailController.text = resumeData.profile!.email;
      _linkedinController.text = resumeData.profile!.linkedin ?? '';
      _githubController.text = resumeData.profile!.github ?? '';
      _websiteController.text = resumeData.profile!.website ?? '';
      _summaryController.text = resumeData.profile!.summary ?? '';
    } else if (currentUser != null) {
      // Do not auto-fill email; user will enter manually
    }
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      final profile = Profile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        linkedin: _linkedinController.text.trim().isEmpty
            ? null
            : _linkedinController.text.trim(),
        github: _githubController.text.trim().isEmpty
            ? null
            : _githubController.text.trim(),
        website: _websiteController.text.trim().isEmpty
            ? null
            : _websiteController.text.trim(),
        summary: _summaryController.text.trim().isEmpty
            ? null
            : _summaryController.text.trim(),
      );

      ref.read(resumeProvider.notifier).updateProfile(profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: AppConstants.sectionProfile,
      child: Form(
        key: _formKey,
        onChanged: () => _updateProfile(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name
            NotionTextField(
              label: AppConstants.labelFullName,
              controller: _nameController,
              hintText: AppConstants.placeholderName,
              validator: (value) =>
                  Validators.validateRequired(value, fieldName: 'Full name'),
              textCapitalization: TextCapitalization.words,
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Phone
            NotionTextField(
              label: AppConstants.labelPhone,
              controller: _phoneController,
              hintText: AppConstants.placeholderPhone,
              keyboardType: TextInputType.phone,
              validator: Validators.validatePhone,
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Email
            NotionTextField(
              label: AppConstants.labelEmail,
              controller: _emailController,
              hintText: AppConstants.placeholderEmail,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
              enabled: true,
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // LinkedIn URL
            NotionTextField(
              label: AppConstants.labelLinkedIn,
              controller: _linkedinController,
              hintText: AppConstants.placeholderLinkedIn,
              keyboardType: TextInputType.url,
              validator: Validators.validateLinkedIn,
              helperText:
                  'Optional - Enter your LinkedIn profile URL or username',
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // GitHub URL
            NotionTextField(
              label: AppConstants.labelGitHub,
              controller: _githubController,
              hintText: AppConstants.placeholderGitHub,
              keyboardType: TextInputType.url,
              validator: Validators.validateGitHub,
              helperText:
                  'Optional - Enter your GitHub profile URL or username',
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Website URL
            NotionTextField(
              label: AppConstants.labelWebsite,
              controller: _websiteController,
              hintText: AppConstants.placeholderWebsite,
              keyboardType: TextInputType.url,
              validator: Validators.validateURL,
              helperText: 'Optional - Enter your personal website URL',
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Professional Summary
            NotionTextField(
              label: AppConstants.labelSummary,
              controller: _summaryController,
              hintText: AppConstants.placeholderSummary,
              maxLines: 4,
              maxLength: 500,
              validator: (value) => Validators.validateLength(
                value,
                maxLength: 500,
                fieldName: 'Summary',
              ),
              helperText:
                  'Optional - Brief summary of your professional background (max 500 characters)',
            ),
          ],
        ),
      ),
    );
  }
}
