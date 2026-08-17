import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../services/haptics.dart';

class HealthTrendsHeroCard extends StatelessWidget {
  const HealthTrendsHeroCard({
    super.key,
    this.tag = 'Bearable',
    this.title = 'Health trends',
    this.periodLabel = '30Days',
    this.subtitle = 'Current Period',
    this.progress = 0.70,
    this.buttonText = 'View weekly report',
    this.onTapButton,
  });

  final String tag;
  final String title;
  final String periodLabel;
  final String subtitle;
  final double progress;
  final String buttonText;
  final VoidCallback? onTapButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT SQUIRCLE HERO IMAGE CONTAINER
              Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF3F1F6,
                  ), // Soft subtle grey from reference image
                  borderRadius: BorderRadius.circular(28),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    'assets/icon/nivora.png',
                    width: 105,
                    height: 105,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.fitness_center_rounded,
                        size: 40,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // RIGHT COLUMN DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PURPLE PILL TAG
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFD4C0FA,
                        ), // Pastel purple from reference
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // MAIN TITLE
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkText,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // DETAILS ROW WITH DARK CIRCLE ICONS
                    Row(
                      children: [
                        _IconBadge(icon: Icons.access_time_rounded),
                        const SizedBox(width: 4),
                        Text(
                          periodLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.mutedText,
                          ),
                        ),
                        const SizedBox(width: 12),
                        _IconBadge(icon: Icons.calendar_month_rounded),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            subtitle,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.mutedText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // SOFT YELLOW PROGRESS BAR
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFFFF9E6,
                            ), // Soft light cream track
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: progress.clamp(0.05, 1.0),
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFDE49B,
                              ), // Soft yellow fill
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // FULL-WIDTH BLACK ACTION BUTTON
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF14121B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              onPressed: () {
                Haptics.selection();
                onTapButton?.call();
              },
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(
        color: Color(0xFF1B233A), // Dark navy circle from reference
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 11, color: Colors.white),
    );
  }
}
