import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Super Hello typography system
class AppTextStyles {
  // Font family
  static const String fontFamily = 'Inter';

  // Hero Title - "super hello" style
  static TextStyle get heroTitle => GoogleFonts.inter(
    fontSize: 96,
    fontWeight: FontWeight.w800,
    color: AppColors.textWhite,
    letterSpacing: -2,
  );

  // Heading Styles (Super Hello inspired)
  static TextStyle get h1 => GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: -1,
    height: 1.2,
  );

  static TextStyle get h2 => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static TextStyle get h3 => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: -0.4,
    height: 1.4,
  );

  // Tagline style
  static TextStyle get tagline => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
    height: 1.4,
  );

  // Section Heading
  static TextStyle get sectionHeading => GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: -1,
  );

  // Body Text (Super Hello style)
  static TextStyle get bodyText => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.6,
  );

  // Body Styles (legacy compatibility)
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.6,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // Button Text (Super Hello style)
  static TextStyle get buttonText => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: 0,
  );

  static TextStyle get buttonTextSecondary => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // Card Title (Super Hello style)
  static TextStyle get cardTitle => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  // Label Text
  static TextStyle get labelText => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: AppColors.textSecondary,
  );

  // Caption Text
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    color: AppColors.textTertiary,
  );

  // Error Text
  static TextStyle get errorText => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    color: AppColors.error,
  );

  // Helper Text
  static TextStyle get helperText => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    color: AppColors.textTertiary,
  );

  // Link Text
  static TextStyle get linkText => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );
}
