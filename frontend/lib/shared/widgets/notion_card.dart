import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Notion-style card component
class NotionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showHoverEffect;

  const NotionCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.onTap,
    this.showHoverEffect = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textDark, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.textDark,
            offset: Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: backgroundColor ?? AppColors.cardWhite,
          child: InkWell(
            onTap: onTap,
            hoverColor: showHoverEffect
                ? AppColors.cardPink.withOpacity(0.3)
                : null,
            child: Container(
              padding:
                  padding ?? const EdgeInsets.all(AppConstants.cardPadding),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
