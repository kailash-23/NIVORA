import 'package:flutter/material.dart';

class NivoraTodayData {
  const NivoraTodayData({
    required this.dateLabel,
    required this.dayLabel,
    required this.dayProgress,
    required this.goalProgress,
    required this.priorityItems,
    required this.anchors,
    required this.queue,
    required this.habitsDueToday,
    required this.goalSnapshots,
  });

  final String dateLabel;
  final String dayLabel;
  final double dayProgress;
  final List<NivoraPriorityItem> priorityItems;
  final List<NivoraAnchorItem> anchors;
  final List<NivoraQueueItem> queue;
  final List<NivoraHabitItem> habitsDueToday;
  final List<NivoraGoalSnapshot> goalSnapshots;
  final double goalProgress;
}

class NivoraPriorityItem {
  const NivoraPriorityItem({
    required this.title,
    required this.subtitle,
    required this.weight,
    required this.tint,
  });

  final String title;
  final String subtitle;
  final String weight;
  final Color tint;
}

class NivoraAnchorItem {
  const NivoraAnchorItem({
    required this.title,
    required this.time,
    required this.note,
  });

  final String title;
  final String time;
  final String note;
}

class NivoraQueueItem {
  const NivoraQueueItem({
    required this.title,
    required this.context,
    required this.priority,
    required this.isActive,
  });

  final String title;
  final String context;
  final String priority;
  final bool isActive;
}

class NivoraHabitItem {
  const NivoraHabitItem({
    required this.title,
    required this.duration,
    required this.completion,
  });

  final String title;
  final String duration;
  final String completion;
}

class NivoraGoalSnapshot {
  const NivoraGoalSnapshot({
    required this.title,
    required this.progress,
    required this.target,
  });

  final String title;
  final double progress;
  final String target;
}

class NivoraMockData {
  static const today = NivoraTodayData(
    dateLabel: 'Mon, 16 Aug',
    dayLabel: 'Today',
    dayProgress: 0.64,
    goalProgress: 0.72,
    priorityItems: [
      NivoraPriorityItem(
        title: 'Finish launch brief',
        subtitle: 'Pressure: High · due before noon',
        weight: 'P1',
        tint: Color(0xFFF1E2FF),
      ),
      NivoraPriorityItem(
        title: '15-minute anchor walk',
        subtitle: 'Protect the afternoon reset',
        weight: 'P2',
        tint: Color(0xFFE7F4EE),
      ),
      NivoraPriorityItem(
        title: 'Review habit chain',
        subtitle: 'Keep the daily execution loop intact',
        weight: 'P3',
        tint: Color(0xFFFFF0E4),
      ),
    ],
    anchors: [
      NivoraAnchorItem(
        title: 'Deep work block',
        time: '08:45 - 10:15',
        note: 'No context switching, one target only',
      ),
      NivoraAnchorItem(
        title: 'Midday reset',
        time: '12:30',
        note: 'Walk, hydration, and check queue pressure',
      ),
      NivoraAnchorItem(
        title: 'Execution review',
        time: '17:45',
        note: 'Close loops and prepare tomorrow',
      ),
    ],
    queue: [
      NivoraQueueItem(
        title: 'Draft target summary',
        context: 'Goals · Launch lane',
        priority: 'Urgent',
        isActive: true,
      ),
      NivoraQueueItem(
        title: '30-minute study sprint',
        context: 'Habits · Learning chain',
        priority: 'Important',
        isActive: false,
      ),
      NivoraQueueItem(
        title: 'Inbox cleanup',
        context: 'Pressure · Containment',
        priority: 'Low',
        isActive: false,
      ),
    ],
    habitsDueToday: [
      NivoraHabitItem(
        title: 'Morning review',
        duration: '12 min',
        completion: 'Done',
      ),
      NivoraHabitItem(
        title: 'Fitness block',
        duration: '30 min',
        completion: 'Pending',
      ),
      NivoraHabitItem(
        title: 'Shutdown ritual',
        duration: '8 min',
        completion: 'Pending',
      ),
    ],
    goalSnapshots: [
      NivoraGoalSnapshot(title: 'Launch v1', progress: 0.81, target: 'Q3'),
      NivoraGoalSnapshot(
        title: 'Fitness baseline',
        progress: 0.54,
        target: 'Monthly',
      ),
      NivoraGoalSnapshot(
        title: 'Focus consistency',
        progress: 0.68,
        target: 'Weekly',
      ),
    ],
  );
}
