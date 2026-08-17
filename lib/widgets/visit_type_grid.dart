import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../services/haptics.dart';

class VisitTypeGrid extends StatelessWidget {
  const VisitTypeGrid({super.key, this.title = 'Visit type'});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SECTION HEADER
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.darkText,
                letterSpacing: -0.8,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => Haptics.light(),
              icon: const Icon(
                Icons.tune_rounded,
                size: 20,
                color: AppTheme.darkText,
              ),
            ),
            IconButton(
              onPressed: () => Haptics.light(),
              icon: const Icon(
                Icons.format_list_bulleted_rounded,
                size: 20,
                color: AppTheme.darkText,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 2 LARGE CARDS MATCHING REFERENCE IMAGE
        Row(
          children: [
            // LEFT CARD (SOFT BLUE)
            Expanded(
              child: Container(
                height: 160,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFD9EEFF,
                  ), // Soft sky blue from reference
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Health\nMeasurements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkText,
                        height: 1.2,
                        letterSpacing: -0.4,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.mutedText,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '6:1PM',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.darkText,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 14),

            // RIGHT CARD (SOFT PINK)
            Expanded(
              child: Container(
                height: 160,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF9DCE6,
                  ), // Soft pastel pink from reference
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Meds\nSupplement\'s',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkText,
                        height: 1.2,
                        letterSpacing: -0.4,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppTheme.darkText.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.north_east_rounded,
                          size: 20,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
