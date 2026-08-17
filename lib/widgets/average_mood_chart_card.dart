import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../services/haptics.dart';

class AverageMoodChartCard extends StatelessWidget {
  const AverageMoodChartCard({super.key, this.title = 'Average Mood'});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkText,
                  letterSpacing: -0.4,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Haptics.light(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceSubtle,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.north_east_rounded,
                    size: 18,
                    color: AppTheme.darkText,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 4 CAPSULE BARS FROM REFERENCE IMAGE
          SizedBox(
            height: 190,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                _CapsuleBar(fillFactor: 1.0, label: '100%'),
                _CapsuleBar(fillFactor: 0.35, label: '35%'),
                _CapsuleBar(fillFactor: 0.75, label: '75%'),
                _CapsuleBar(fillFactor: 0.45, label: '45%'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CapsuleBar extends StatelessWidget {
  const _CapsuleBar({required this.fillFactor, required this.label});

  final double fillFactor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 58,
              decoration: BoxDecoration(
                color: const Color(
                  0xFFF0E8FA,
                ), // Soft lavender capsule background
                borderRadius: BorderRadius.circular(30),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  FractionallySizedBox(
                    heightFactor: fillFactor.clamp(0.1, 1.0),
                    child: Container(
                      width: 58,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC7B2F6), // Filled soft purple
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkText,
            ),
          ),
        ],
      ),
    );
  }
}
