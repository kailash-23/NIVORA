import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class ProgressBannerCard extends StatelessWidget {
  const ProgressBannerCard({
    super.key,
    required this.completionRatio,
    required this.completedCount,
    required this.totalCount,
    this.headline = "Today's Momentum",
  });

  final double completionRatio;
  final int completedCount;
  final int totalCount;
  final String headline;

  @override
  Widget build(BuildContext context) {
    final percentage = (completionRatio * 100).clamp(0, 100).toInt();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6340B4).withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lavenderTint,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 14,
                      color: AppTheme.primaryPurple,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      headline,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryPurple,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '$completedCount of $totalCount habits',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.mutedText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: completionRatio),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        final valPercent = (value * 100).clamp(0, 100).toInt();
                        return Text(
                          '$valPercent%',
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.darkText,
                            letterSpacing: -1.5,
                            height: 1.0,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(
                      percentage == 100
                          ? 'All habits completed! Phenomenal focus.'
                          : percentage >= 50
                          ? 'More than halfway done. Keep it up!'
                          : 'Small consistent steps build great days.',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.mutedText,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 68,
                height: 68,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: completionRatio),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 68,
                          height: 68,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 7,
                            backgroundColor: AppTheme.surfaceSubtle,
                            color: AppTheme.primaryPurple,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Icon(
                          percentage == 100
                              ? Icons.task_alt_rounded
                              : Icons.bolt_rounded,
                          color: AppTheme.primaryPurple,
                          size: 26,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: completionRatio),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: AppTheme.surfaceSubtle,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryPurple,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
