import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../services/haptics.dart';

class HealthTrackerCard extends StatelessWidget {
  const HealthTrackerCard({
    super.key,
    this.title = 'Health Tracker',
    this.weeklyLevels,
    this.onTapArrow,
  });

  final String title;
  final List<double>? weeklyLevels;
  final VoidCallback? onTapArrow;

  @override
  Widget build(BuildContext context) {
    final nowWeekday = DateTime.now().weekday; // 1 = Mon, 2 = Tue, ..., 7 = Sun
    final defaultLevels = [0.55, 0.95, 0.70, 0.48, 0.82];
    final levels = weeklyLevels ?? defaultLevels;
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(
          0xFFCBB5F6,
        ), // Soft vibrant lavender from reference image
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9C7CDD).withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW
          Row(
            children: [
              const Icon(
                Icons.favorite_rounded,
                size: 22,
                color: AppTheme.darkText,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkText,
                  letterSpacing: -0.4,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Haptics.selection();
                  onTapArrow?.call();
                },
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppTheme.darkText.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.north_east_rounded,
                    size: 22,
                    color: AppTheme.darkText,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // DYNAMIC BAR CHART MATCHING REFERENCE IMAGE
          SizedBox(
            height: 190,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(5, (index) {
                final dayNumber = index + 1; // 1 = Mon, 2 = Tue, ...
                final isSolid =
                    dayNumber == nowWeekday ||
                    (nowWeekday > 5 && dayNumber == 2);
                final level = index < levels.length ? levels[index] : 0.6;

                return _PillBar(
                  label: days[index],
                  heightFactor: level.clamp(0.2, 1.0),
                  isSolid: isSolid,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillBar extends StatelessWidget {
  const _PillBar({
    required this.label,
    required this.heightFactor,
    required this.isSolid,
  });

  final String label;
  final double heightFactor;
  final bool isSolid;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: heightFactor,
              child: Container(
                width: 52,
                decoration: BoxDecoration(
                  color: isSolid ? AppTheme.darkText : null,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: isSolid
                    ? null
                    : CustomPaint(painter: _HatchPatternPainter()),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.darkText,
          ),
        ),
      ],
    );
  }
}

class _HatchPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final clipRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(28),
    );
    canvas.clipRRect(clipRRect);

    final paint = Paint()
      ..color = AppTheme.darkText.withValues(alpha: 0.9)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    const step = 7.0;
    for (double i = -size.height; i < size.width + size.height; i += step) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
