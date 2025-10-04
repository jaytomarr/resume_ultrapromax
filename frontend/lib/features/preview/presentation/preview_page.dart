import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: undefined_prefixed_name
import 'dart:ui_web' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/notion_button.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../services/pdf_service.dart';
import '../../builder/providers/resume_provider.dart';

/// Preview page with PDF generation and download
class PreviewPage extends ConsumerStatefulWidget {
  const PreviewPage({super.key});

  @override
  ConsumerState<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends ConsumerState<PreviewPage> {
  final PDFService _pdfService = PDFService();
  bool _isLoading = false;
  String? _errorMessage;
  String? _pdfUrl;
  String? _iframeViewType;

  @override
  void initState() {
    super.initState();
    _generatePDF();
  }

  Future<void> _generatePDF() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get resume data from provider
      final resumeData = ref.read(resumeProvider);

      // Generate PDF
      final pdfUrl = await _pdfService.generatePDF(resumeData);

      if (!mounted) return;
      _setupInlinePreview(pdfUrl);
    } catch (e) {
      setState(() {
        _errorMessage = AppConstants.errorPDFGenerationFailed;
        _isLoading = false;
      });
    }
  }

  void _setupInlinePreview(String url) {
    setState(() {
      _pdfUrl = url;
      _isLoading = false;
    });

    if (kIsWeb && _pdfUrl != null) {
      // Register a unique view type for the iframe to avoid duplicate registration errors
      final viewType = 'pdf-frame-${DateTime.now().millisecondsSinceEpoch}';
      // Register factory that builds an iframe pointing to the blob/data URL
      ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
        // Add PDF.js viewer parameters to hide controls and set zoom to fit width
        final enhancedPdfUrl = '$_pdfUrl#toolbar=0&navpanes=0&zoom=page-width';

        final iframe = html.IFrameElement()
          ..src = enhancedPdfUrl
          ..style.border = 'none'
          ..width = '100%'
          ..height = '100%';
        return iframe;
      });
      setState(() {
        _iframeViewType = viewType;
      });
    }
  }

  void _downloadPDF() {
    if (_pdfUrl == null || !kIsWeb) return;
    // Trigger browser download on web using a temporary anchor element
    final anchor = html.AnchorElement(href: _pdfUrl!)
      ..download = 'resume.pdf'
      ..target = '_blank';
    anchor.click();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppConstants.messagePDFDownloadedSuccessfully),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  void dispose() {
    // Revoke blob URL to free memory on web
    if (kIsWeb && _pdfUrl != null) {
      html.Url.revokeObjectUrl(_pdfUrl!);
    }
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      body: Stack(
        children: [
          Column(
            children: [
              // Top Action Bar
              Container(
                height: 64,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingLG,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.bgDark,
                  border: Border(
                    bottom: BorderSide(color: AppColors.textDark, width: 2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textDark,
                      offset: Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Back Button
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _goBack,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryYellow,
                          foregroundColor: AppColors.textDark,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: AppColors.textDark,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.arrow_back, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              AppConstants.buttonBackToEditor,
                              style: AppTextStyles.buttonText.copyWith(
                                color: AppColors.textDark,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Download Button
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _pdfUrl != null ? _downloadPDF : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pdfUrl != null
                              ? AppColors.accentOrange
                              : AppColors.cardPink,
                          foregroundColor: AppColors.textDark,
                          disabledBackgroundColor: AppColors.cardPink,
                          disabledForegroundColor: AppColors.textDark,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: AppColors.textDark,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.download,
                              size: 18,
                              color: _isLoading
                                  ? AppColors.textDark
                                  : AppColors.textDark,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppConstants.buttonDownloadPDF,
                              style: AppTextStyles.buttonText.copyWith(
                                color: AppColors.textDark,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PDF Viewer Area
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(AppConstants.spacingLG),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.textDark, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.textDark,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(AppConstants.spacingLG),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 800,
                        maxHeight: 1000,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowMedium,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _buildPDFContent(),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Loading Overlay
          if (_isLoading)
            LoadingOverlay(
              message: AppConstants.loadingGenerating,
              isLoading: _isLoading,
            ),

          // Error Message
          if (_errorMessage != null)
            Positioned(
              top: 100,
              left: AppConstants.spacingLG,
              right: AppConstants.spacingLG,
              child: Container(
                padding: const EdgeInsets.all(AppConstants.spacingMD),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white, size: 20),
                    const SizedBox(width: AppConstants.spacingSM),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _errorMessage = null),
                      icon: Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPDFContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppConstants.spacingMD),
            Text('Generating your resume...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppConstants.spacingMD),
            Text(
              'Failed to generate PDF',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppConstants.spacingSM),
            Text(
              _errorMessage!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingLG),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NotionButton(
                  text: AppConstants.buttonRetry,
                  icon: Icons.refresh,
                  isSecondary: true,
                  onPressed: _generatePDF,
                ),
                const SizedBox(width: AppConstants.spacingSM),
                NotionButton(
                  text: AppConstants.buttonBackToEditor,
                  icon: Icons.arrow_back,
                  onPressed: _goBack,
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (_pdfUrl != null) {
      if (kIsWeb && _iframeViewType != null) {
        return HtmlElementView(viewType: _iframeViewType!);
      }
      // Fallback UI for non-web
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, size: 64, color: AppColors.primary),
            const SizedBox(height: AppConstants.spacingMD),
            Text(
              'PDF Generated Successfully! Use Download to view.',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      );
    }

    return const Center(child: Text('No PDF available'));
  }
}
