import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';

/// Google Sign-In dialog component
class GoogleSignInDialog extends ConsumerStatefulWidget {
  const GoogleSignInDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<GoogleSignInDialog> createState() => _GoogleSignInDialogState();
}

class _GoogleSignInDialogState extends ConsumerState<GoogleSignInDialog> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);

      // Check if user is already authenticated
      if (authService.isAuthenticated) {
        // User is already signed in, close dialog and navigate
        Navigator.of(context).pop();
        return;
      }

      // Perform Google Sign-In
      final result = await authService.signInWithGoogle();

      if (result != null) {
        // Sign-in successful, close dialog
        Navigator.of(context).pop();
      } else {
        // User cancelled sign-in, just close dialog
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e.toString());
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('network')) {
      return 'No internet connection. Please try again.';
    } else if (error.contains('cancelled')) {
      return 'Sign-in was cancelled.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.textDark, width: 2),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.textDark,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 32), // Spacer
                Text(
                  'Sign in to continue',
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: 20,
                    color: AppColors.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: AppColors.textDark, size: 20),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Google Sign-In Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleGoogleSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryYellow,
                  foregroundColor: AppColors.textDark,
                  disabledBackgroundColor: AppColors.primaryYellow,
                  disabledForegroundColor: AppColors.textDark,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppColors.textDark, width: 2),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.textDark,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google Logo (Super Hello style)
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.textDark,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.textDark,
                                  offset: Offset(1, 1),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.g_mobiledata,
                              color: AppColors.cardWhite,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            AppConstants.buttonSignInWithGoogle,
                            style: AppTextStyles.buttonText.copyWith(
                              color: AppColors.textDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // Error Message
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardPink,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.textDark, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.textDark,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.textDark,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
