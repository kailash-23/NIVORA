import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class FactorsDonutChartCard extends StatelessWidget {
  const FactorsDonutChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
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
      child: Row(
        children: [
          // LEFT LEGEND METRICS MATCHING REFERENCE IMAGE 2
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _LegendItem(
                  color: Color(0xFFFDE49B),
                  label: 'Factors',
                  value: '28',
                ),
                SizedBox(height: 16),
                _LegendItem(
                  color: Color(0xFFD4C0FA),
                  label: 'Mood',
                  value: '20',
                ),
                SizedBox(height: 16),
                _LegendItem(
                  color: Color(0xFF14121B),
                  label: 'Same day',
                  value: '31',
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // RIGHT DONUT RING CHART WITH NUMBERED BADGES MATCHING REFERENCE IMAGE
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _DonutChartPainter()),
                ),
                // BADGE 1 (DARK GREY BADGE ON BLACK ARC)
                Positioned(
                  top: 14,
                  left: 18,
                  child: _BadgeCircle(
                    number: '1',
                    bgColor: const Color(0xFF62696C),
                    textColor: Colors.white,
                  ),
                ),
                // BADGE 3 (SOFT YELLOW BADGE ON YELLOW ARC)
                Positioned(
                  top: 18,
                  right: 12,
                  child: _BadgeCircle(
                    number: '3',
                    bgColor: const Color(0xFFFFF1C6),
                    textColor: AppTheme.darkText,
                  ),
                ),
                // BADGE 2 (SOFT LAVENDER BADGE ON PURPLE ARC)
                Positioned(
                  bottom: 12,
                  right: 22,
                  child: _BadgeCircle(
                    number: '2',
                    bgColor: const Color(0xFFECE1FD),
                    textColor: AppTheme.darkText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCircle extends StatelessWidget {
  const _BadgeCircle({
    required this.number,
    required this.bgColor,
    required this.textColor,
  });

  final String number;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.mutedText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.darkText,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const strokeWidth = 32.0;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Segment 1 (Black): start -0.5pi, sweep 1.1pi
    paint.color = const Color(0xFF14121B);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 1.1, false, paint);

    // Segment 2 (Yellow): start 0.6pi, sweep 0.5pi
    paint.color = const Color(0xFFFDE49B);
    canvas.drawArc(rect, math.pi * 0.6, math.pi * 0.5, false, paint);

    // Segment 3 (Soft Purple): start 1.1pi, sweep 0.4pi
    paint.color = const Color(0xFFD4C0FA);
    canvas.drawArc(rect, math.pi * 1.1, math.pi * 0.4, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
