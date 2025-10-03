import 'package:flutter/material.dart';

/// Notion-inspired color palette for Resume UltraProMax
class AppColors {
  // Primary (Light mode inspired by Notion)
  static const Color background = Color(0xFFFFFFFF); // Pure white
  static const Color surface = Color(0xFFF7F6F3); // Warm off-white
  static const Color surfaceHover = Color(
    0xFFEFEEEB,
  ); // Slightly darker on hover

  // Text
  static const Color textPrimary = Color(0xFF37352F); // Dark brown-grey
  static const Color textSecondary = Color(0xFF787774); // Medium grey
  static const Color textTertiary = Color(0xFF9B9A97); // Light grey

  // Borders & Dividers
  static const Color border = Color(0xFFE9E9E7); // Subtle border
  static const Color divider = Color(0xFFEDECE9); // Divider line

  // Sidebar
  static const Color sidebarBackground = Color(0xFFF7F6F3);
  static const Color sidebarHover = Color(0xFFEFEEEB);
  static const Color sidebarActive = Color(0xFFE9E9E7);

  // Accents
  static const Color primary = Color(0xFF2383E2); // Notion blue
  static const Color primaryHover = Color(0xFF1F7CD6);

  // Functional
  static const Color error = Color(0xFFEB5757);
  static const Color success = Color(0xFF0F7B6C);
  static const Color warning = Color(0xFFF2994A);

  // Overlay
  static const Color overlayBackground = Color(
    0x80000000,
  ); // Semi-transparent black

  // Additional colors for better UX
  static const Color disabled = Color(0xFFC4C4C4);
  static const Color disabledText = Color(0xFF9B9A97);

  // Card shadows
  static const Color shadowLight = Color(0x0A000000); // Very subtle shadow
  static const Color shadowMedium = Color(0x14000000); // Medium shadow
}
