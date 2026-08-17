import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../services/haptics.dart';

class BarChartDataPoint {
  const BarChartDataPoint({
    required this.label,
    required this.value,
    this.isToday = false,
  });

  final String label;
  final double value; // 0.0 to 1.0
  final bool isToday;
}

class CustomBarChart extends StatefulWidget {
  const CustomBarChart({
    super.key,
    required this.dataPoints,
    this.title = 'Weekly Habit Consistency',
    this.subtitle = 'Daily completion rate over the last 7 days',
  });

  final List<BarChartDataPoint> dataPoints;
  final String title;
  final String subtitle;

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6340B4).withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkText,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.mutedText,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceSubtle,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  '7-Day',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(widget.dataPoints.length, (index) {
                final point = widget.dataPoints[index];
                final isSelected = _selectedIndex == index;
                final barHeightPercentage = point.value.clamp(0.05, 1.0);

                return GestureDetector(
                  onTap: () {
                    Haptics.selection();
                    setState(() {
                      _selectedIndex = isSelected ? null : index;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        opacity: isSelected ? 1.0 : 0.0,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.darkText,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${(point.value * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0,
                              end: barHeightPercentage,
                            ),
                            duration: Duration(
                              milliseconds: 500 + (index * 60),
                            ),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return FractionallySizedBox(
                                heightFactor: value,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 24,
                                  decoration: BoxDecoration(
                                    color: point.isToday
                                        ? AppTheme.primaryPurple
                                        : isSelected
                                        ? AppTheme.primaryPurple
                                        : AppTheme.surfaceSubtle,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: point.isToday || isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppTheme.primaryPurple
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        point.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: point.isToday || isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: point.isToday || isSelected
                              ? AppTheme.primaryPurple
                              : AppTheme.mutedText,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
