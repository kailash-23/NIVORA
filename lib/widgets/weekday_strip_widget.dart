import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../services/haptics.dart';

class WeekdayStripWidget extends StatefulWidget {
  const WeekdayStripWidget({super.key, this.selectedDate, this.onDateSelected});

  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;

  @override
  State<WeekdayStripWidget> createState() => _WeekdayStripWidgetState();
}

class _WeekdayStripWidgetState extends State<WeekdayStripWidget> {
  late DateTime _currentWeekBaseDate;
  final ScrollController _scrollController = ScrollController();

  static const List<Color> _bannerColors = [
    Color(0xFFD8D2FB), // Sun - Lavender
    Color(0xFFD4C0FA), // Mon - Purple
    Color(0xFFF9D0DF), // Tue - Pink
    Color(0xFFFFF2C2), // Wed - Yellow
    Color(0xFFC7F3E2), // Thu - Mint
    Color(0xFFCBE2FE), // Fri - Blue
    Color(0xFFF9CBE6), // Sat - Magenta
  ];

  static const List<Color> _cardColors = [
    Color(0xFFF3EDFD),
    Color(0xFFF3EDFD),
    Color(0xFFFDEBF2),
    Color(0xFFFFFBEA),
    Color(0xFFE8FAF3),
    Color(0xFFEAF3FF),
    Color(0xFFFDEAF3),
  ];

  static const List<String> _dayLabels = [
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
  ];

  @override
  void initState() {
    super.initState();
    _currentWeekBaseDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WeekdayStripWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != null &&
        widget.selectedDate != oldWidget.selectedDate) {
      _currentWeekBaseDate = widget.selectedDate!;
    }
  }

  void _previousWeek() {
    Haptics.selection();
    setState(() {
      _currentWeekBaseDate = _currentWeekBaseDate.subtract(
        const Duration(days: 7),
      );
    });
    final sundayOffset = _currentWeekBaseDate.weekday % 7;
    final sunday = _currentWeekBaseDate.subtract(Duration(days: sundayOffset));
    widget.onDateSelected?.call(sunday);
  }

  void _nextWeek() {
    Haptics.selection();
    setState(() {
      _currentWeekBaseDate = _currentWeekBaseDate.add(const Duration(days: 7));
    });
    final sundayOffset = _currentWeekBaseDate.weekday % 7;
    final sunday = _currentWeekBaseDate.subtract(Duration(days: sundayOffset));
    widget.onDateSelected?.call(sunday);
  }

  String _monthAbbr(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Sunday is day 0 in our week calculation
    final sundayOffset = _currentWeekBaseDate.weekday % 7;
    final weekSunday = _currentWeekBaseDate.subtract(
      Duration(days: sundayOffset),
    );
    final weekSaturday = weekSunday.add(const Duration(days: 6));
    final weekDays = List.generate(
      7,
      (index) => weekSunday.add(Duration(days: index)),
    );

    final activeSelected = widget.selectedDate ?? _currentWeekBaseDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DYNAMIC WEEK HEADER WITH NAVIGATION ARROWS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_monthAbbr(weekSunday.month)} ${weekSunday.day} - ${weekSunday.month != weekSaturday.month ? '${_monthAbbr(weekSaturday.month)} ' : ''}${weekSaturday.day}, ${weekSaturday.year}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppTheme.darkText,
                letterSpacing: -0.2,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: _previousWeek,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.surfaceSubtle,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      size: 18,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _nextWeek,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.surfaceSubtle,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),

        // 5 VISIBLE BOXES HORIZONTALLY SCROLLABLE WEEKDAY STRIP (SUNDAY START)
        LayoutBuilder(
          builder: (context, constraints) {
            // Exactly 5 boxes visible at a time on screen
            final cardWidth = (constraints.maxWidth - (4 * 8)) / 5;

            return SizedBox(
              height: 114,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 7,
                itemBuilder: (context, index) {
                  final dayDate = weekDays[index];
                  final isToday =
                      now.year == dayDate.year &&
                      now.month == dayDate.month &&
                      now.day == dayDate.day;
                  final isSelected =
                      activeSelected.year == dayDate.year &&
                      activeSelected.month == dayDate.month &&
                      activeSelected.day == dayDate.day;

                  return Container(
                    width: cardWidth,
                    margin: EdgeInsets.only(right: index == 6 ? 0 : 8),
                    child: GestureDetector(
                      onTap: () {
                        Haptics.selection();
                        setState(() {
                          _currentWeekBaseDate = dayDate;
                        });
                        widget.onDateSelected?.call(dayDate);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        decoration: BoxDecoration(
                          color: isToday
                              ? const Color(
                                  0xFFD4C0FA,
                                ) // Vibrant purple for Today
                              : (isSelected
                                    ? _bannerColors[index]
                                    : _cardColors[index]),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isToday
                                ? AppTheme
                                      .darkText // Bold black outline for Today
                                : (isSelected
                                      ? AppTheme.darkText
                                      : _bannerColors[index].withValues(
                                          alpha: 0.5,
                                        )),
                            width: isToday ? 2.8 : (isSelected ? 2.2 : 1.0),
                          ),
                          boxShadow: isToday || isSelected
                              ? [
                                  BoxShadow(
                                    color: isToday
                                        ? const Color(
                                            0xFF6340B4,
                                          ).withValues(alpha: 0.25)
                                        : Colors.black.withValues(alpha: 0.10),
                                    blurRadius: 14,
                                    offset: const Offset(0, 5),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          children: [
                            // TOP BANNER
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: _bannerColors[index],
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                _dayLabels[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.darkText,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),

                            // BODY CONTENT
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isToday) ...[
                                    // DISTINCT PRESENT DAY (TODAY) BADGE
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.darkText,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        'TODAY',
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                  ] else if (isSelected) ...[
                                    const Text(
                                      '😊',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 2),
                                  ],
                                  Text(
                                    '${dayDate.day}',
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.darkText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
