import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// Info cards section showing how the app works
class InfoCards extends StatelessWidget {
  const InfoCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      decoration: const BoxDecoration(color: AppColors.primaryYellow),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determine if mobile or desktop
            bool isMobile = constraints.maxWidth < 768;

            return Container(
              width: isMobile
                  ? constraints.maxWidth * 0.9
                  : constraints.maxWidth * 0.9,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 40,
                vertical: isMobile ? 12 : 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'How it works',
                    style: AppTextStyles.sectionHeading.copyWith(
                      fontSize: isMobile ? 20 : 28,
                      color: AppColors.textDark,
                      fontWeight: isMobile ? FontWeight.w700 : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                  if (isMobile)
                    SizedBox(
                      width: constraints.maxWidth * 0.8,
                      child: Column(
                        children: [
                          _ProcessCard(
                            icon: Icons.edit,
                            title: 'Fill Details',
                            description:
                                'Enter your professional information using our intuitive form.',
                            isMobile: isMobile,
                          ),
                          SizedBox(height: isMobile ? 12 : 16),
                          _ProcessCard(
                            icon: Icons.visibility,
                            title: 'Preview',
                            description:
                                'See how your resume looks before downloading.',
                            isMobile: isMobile,
                          ),
                          SizedBox(height: isMobile ? 12 : 16),
                          _ProcessCard(
                            icon: Icons.download,
                            title: 'Download',
                            description:
                                'Get your professional PDF resume instantly.',
                            isMobile: isMobile,
                          ),
                        ],
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ProcessCard(
                            icon: Icons.edit,
                            title: 'Fill Details',
                            description:
                                'Enter your professional information using our intuitive form.',
                            isMobile: isMobile,
                          ),
                          SizedBox(width: 24),
                          _ProcessCard(
                            icon: Icons.visibility,
                            title: 'Preview',
                            description:
                                'See how your resume looks before downloading.',
                            isMobile: isMobile,
                          ),
                          SizedBox(width: 24),
                          _ProcessCard(
                            icon: Icons.download,
                            title: 'Download',
                            description:
                                'Get your professional PDF resume instantly.',
                            isMobile: isMobile,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProcessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isMobile;

  const _ProcessCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isMobile ? double.infinity : 280,
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(isMobile ? 8 : 20),
        border: Border.all(color: AppColors.textDark, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDark,
            offset: Offset(isMobile ? 2 : 4, isMobile ? 2 : 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon Container
          Container(
            height: isMobile ? 60 : 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardPink,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMobile ? 6 : 18),
                topRight: Radius.circular(isMobile ? 6 : 18),
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: isMobile ? 30 : 50,
                color: AppColors.textDark,
              ),
            ),
          ),

          // Content
          Container(
            padding: EdgeInsets.all(isMobile ? 10 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: isMobile ? 20 : 22,
                    fontWeight: isMobile ? FontWeight.w700 : null,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 8 : 12),
                Text(
                  description,
                  style: AppTextStyles.bodyText.copyWith(
                    fontSize: isMobile ? 14 : 14,
                    height: 1.4,
                    fontWeight: isMobile ? FontWeight.w400 : null,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
