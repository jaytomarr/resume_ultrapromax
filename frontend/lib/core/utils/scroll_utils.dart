import 'package:flutter/material.dart';

/// Scroll utilities for smooth navigation and animations
class ScrollUtils {
  /// Smoothly scroll to a specific section
  static void scrollToSection(
    BuildContext context,
    GlobalKey key, {
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeOut,
    double alignment = 0.1,
  }) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: duration,
        curve: curve,
        alignment: alignment,
      );
    }
  }

  /// Scroll to top of a scrollable widget
  static void scrollToTop(ScrollController controller) {
    controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  /// Scroll to bottom of a scrollable widget
  static void scrollToBottom(
    ScrollController controller,
    double maxScrollExtent,
  ) {
    controller.animateTo(
      maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  /// Check if user is near the bottom of scroll
  static bool isNearBottom(
    ScrollController controller, {
    double threshold = 100.0,
  }) {
    if (!controller.hasClients) return false;
    return controller.position.pixels >=
        controller.position.maxScrollExtent - threshold;
  }

  /// Check if user is near the top of scroll
  static bool isNearTop(
    ScrollController controller, {
    double threshold = 100.0,
  }) {
    if (!controller.hasClients) return false;
    return controller.position.pixels <= threshold;
  }

  /// Get current scroll position as percentage
  static double getScrollPercentage(ScrollController controller) {
    if (!controller.hasClients) return 0.0;
    return controller.position.pixels / controller.position.maxScrollExtent;
  }

  /// Smooth scroll to a specific offset
  static void scrollToOffset(
    ScrollController controller,
    double offset, {
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeOut,
  }) {
    controller.animateTo(offset, duration: duration, curve: curve);
  }
}
