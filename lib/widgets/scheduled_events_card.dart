import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/event.dart';
import '../services/haptics.dart';

class ScheduledEventsCard extends StatelessWidget {
  const ScheduledEventsCard({
    super.key,
    required this.events,
    this.selectedDate,
    this.onTapAddEvent,
  });

  final List<NivoraEvent> events;
  final DateTime? selectedDate;
  final VoidCallback? onTapAddEvent;

  @override
  Widget build(BuildContext context) {
    final displayDate = selectedDate ?? DateTime.now();

    // Filter events for selected date (or fallback to sample events if empty)
    final filteredEvents = events.where((e) {
      return e.startAt.year == displayDate.year &&
          e.startAt.month == displayDate.month &&
          e.startAt.day == displayDate.day;
    }).toList();

    // Default sample events if none scheduled yet
    final displayEvents = filteredEvents.isNotEmpty
        ? filteredEvents
        : [
            NivoraEvent(
              id: 'sample-1',
              userId: 'user-1',
              title: 'Health & Wellness Review',
              description: 'Routine checkup and habit progress review',
              startAt: DateTime(
                displayDate.year,
                displayDate.month,
                displayDate.day,
                10,
                0,
              ),
              endAt: DateTime(
                displayDate.year,
                displayDate.month,
                displayDate.day,
                11,
                0,
              ),
              completed: false,
              isRepeated: false,
              recurrenceRule: 'Single Event',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
            NivoraEvent(
              id: 'sample-2',
              userId: 'user-1',
              title: 'Daily Mindfulness & Hydration',
              description: 'Guided breathwork session',
              startAt: DateTime(
                displayDate.year,
                displayDate.month,
                displayDate.day,
                16,
                30,
              ),
              endAt: DateTime(
                displayDate.year,
                displayDate.month,
                displayDate.day,
                17,
                0,
              ),
              completed: false,
              isRepeated: true,
              recurrenceRule: 'Repeated Daily',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ];

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER ROW
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4C0FA), // Pastel purple
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.event_note_rounded,
                  size: 20,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scheduled Events',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkText,
                        letterSpacing: -0.4,
                      ),
                    ),
                    Text(
                      '${displayEvents.length} events scheduled for today',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Haptics.selection();
                  onTapAddEvent?.call();
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppTheme.darkText,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(height: 1, color: AppTheme.borderLight),
          const SizedBox(height: 14),

          // EVENTS LIST
          ...displayEvents.map((evt) => _EventTile(event: evt)),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});

  final NivoraEvent event;

  String _formatTime(DateTime date) {
    final hour = date.hour == 0
        ? 12
        : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final startTimeStr = _formatTime(event.startAt);
    final endTimeStr = _formatTime(event.endAt);
    final isRepeated =
        event.isRepeated || event.recurrenceRule.contains('Repeated');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRepeated ? const Color(0xFFE8FAF3) : const Color(0xFFF3EDFD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isRepeated ? const Color(0xFFC7F3E2) : const Color(0xFFD4C0FA),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ),
                    // RECURRENCE TYPE BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isRepeated
                            ? const Color(0xFFC7F3E2)
                            : const Color(0xFFD4C0FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isRepeated
                                ? Icons.autorenew_rounded
                                : Icons.push_pin_rounded,
                            size: 11,
                            color: AppTheme.darkText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.recurrenceRule,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.darkText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 13,
                      color: AppTheme.mutedText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$startTimeStr - $endTimeStr',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.mutedText,
                      ),
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
