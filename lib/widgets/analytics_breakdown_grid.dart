import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class AnalyticsBreakdownGrid extends StatelessWidget {
  const AnalyticsBreakdownGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            // TOP-LEFT: SCREEN TIME CARD
            Expanded(child: _ScreenTimeCard()),
            SizedBox(width: 14),
            // TOP-RIGHT: CALENDAR CARD
            Expanded(child: _CalendarMiniCard()),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: const [
            // BOTTOM-LEFT: MAGNESIUM CARD
            Expanded(child: _MagnesiumCard()),
            SizedBox(width: 14),
            // BOTTOM-RIGHT: TIME CHAD PATTERN GRID CARD
            Expanded(child: _TimeChadCard()),
          ],
        ),
      ],
    );
  }
}

class _ScreenTimeCard extends StatelessWidget {
  const _ScreenTimeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 198,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3EEFB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  size: 18,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Screen time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkText,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                _CapsulePill(heightFactor: 0.88),
                _CapsulePill(heightFactor: 0.48),
                _CapsulePill(heightFactor: 0.72),
                _CapsulePill(heightFactor: 0.98),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '4 Days',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkText,
                ),
              ),
              Text(
                '48h',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.mutedText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CapsulePill extends StatelessWidget {
  const _CapsulePill({required this.heightFactor});

  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: Container(
        width: 24,
        decoration: BoxDecoration(
          color: const Color(
            0xFFD3BEFA,
          ), // Soft lavender capsule from reference
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _CalendarMiniCard extends StatelessWidget {
  const _CalendarMiniCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 198,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3EEFB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Calendar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkText,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ROW 1: '1' plain text, '2' box, '3' box
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    SizedBox(
                      width: 32,
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.darkText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    _NumSquare(num: '2'),
                    SizedBox(width: 6),
                    _NumSquare(num: '3'),
                  ],
                ),
                // ROW 2: '8' box, '12' box
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    _NumSquare(num: '8'),
                    SizedBox(width: 6),
                    _NumSquare(num: '12'),
                  ],
                ),
                // ROW 3: '10' box, '15' box
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _NumSquare(num: '10'),
                    _NumSquare(num: '15'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NumSquare extends StatelessWidget {
  const _NumSquare({required this.num});

  final String num;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFD3BEFA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          num,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _MagnesiumCard extends StatelessWidget {
  const _MagnesiumCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 198,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3EEFB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medication_outlined,
                  size: 18,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Magnesium',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkText,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Stack(
              children: [
                // 4 FAINT VERTICAL GUIDELINES FROM REFERENCE IMAGE
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      4,
                      (index) =>
                          Container(width: 1, color: const Color(0xFFF0EBF6)),
                    ),
                  ),
                ),
                // GANTT SCHEDULE CAPSULES MATCHING REFERENCE IMAGE
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ROW 1: TOP RIGHT CAPSULE
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 76,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD3BEFA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // ROW 2: LEFT CAPSULE + RIGHT CIRCLE DOT
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Container(
                          width: 52,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD3BEFA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD3BEFA),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    // ROW 3: LEFT SMALL CAPSULE + RIGHT LONG CAPSULE
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD3BEFA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD3BEFA),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeChadCard extends StatelessWidget {
  const _TimeChadCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 198,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3EEFB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.crop_square_rounded,
                  size: 18,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Time Chad',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkText,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PatternRow(pattern: const [0, 1, 1, 1, 2]),
                _PatternRow(pattern: const [0, 1, 1, 0, 2]),
                _PatternRow(pattern: const [0, 1, 1, 0, 2]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PatternRow extends StatelessWidget {
  const _PatternRow({required this.pattern});

  // 0: Hatched Mint, 1: Solid Lavender, 2: Light Teal
  final List<int> pattern;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: pattern.map((type) {
        Color bgColor;
        if (type == 0) {
          bgColor = const Color(0xFFD2F5E7); // Hatched mint
        } else if (type == 1) {
          bgColor = const Color(0xFFD3BEFA); // Solid lavender
        } else {
          bgColor = const Color(0xFFE1F5FE); // Light teal
        }

        return Container(
          width: 20,
          height: 24,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: type == 0 ? CustomPaint(painter: _MiniHatchPainter()) : null,
        );
      }).toList(),
    );
  }
}

class _MiniHatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final clipRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(6),
    );
    canvas.clipRRect(clipRRect);

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const step = 4.0;
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
