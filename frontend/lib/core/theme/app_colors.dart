import 'package:flutter/material.dart';

/// Super Hello design system color palette
class AppColors {
  // Super Hello Primary Colors
  static const Color primaryPink = Color(0xFFE4A5D9); // Main pink background
  static const Color primaryYellow = Color(0xFFF4D03F); // Yellow sections
  static const Color accentOrange = Color(0xFFFF6B35); // CTA buttons

  // Text Colors
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Background Colors
  static const Color bgDark = Color(0xFF000000);
  static const Color bgLight = Color(0xFFFFFFFF);

  // Card Colors
  static const Color cardPink = Color(0xFFEEB8E0);
  static const Color cardWhite = Color(0xFFFFFFFF);

  // Legacy compatibility (mapped to Super Hello colors)
  static const Color background = bgLight;
  static const Color surface = Color(0xFFF7F6F3);
  static const Color surfaceHover = Color(0xFFEFEEEB);
  static const Color textPrimary = textDark;
  static const Color textSecondary = Color(0xFF787774);
  static const Color textTertiary = Color(0xFF9B9A97);
  static const Color border = Color(0xFFE9E9E7);
  static const Color divider = Color(0xFFEDECE9);
  static const Color sidebarBackground = Color(0xFFF7F6F3);
  static const Color sidebarHover = Color(0xFFEFEEEB);
  static const Color sidebarActive = Color(0xFFE9E9E7);
  static const Color primary = accentOrange;
  static const Color primaryHover = Color(0xFFE85E2E);
  static const Color error = Color(0xFFEB5757);
  static const Color success = Color(0xFF0F7B6C);
  static const Color warning = Color(0xFFF2994A);
  static const Color overlayBackground = Color(0x80000000);
  static const Color disabled = Color(0xFFC4C4C4);
  static const Color disabledText = Color(0xFF9B9A97);
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowMedium = Color(0x14000000);
}
