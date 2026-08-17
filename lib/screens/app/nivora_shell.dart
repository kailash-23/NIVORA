import 'dart:async';

import 'package:flutter/material.dart';

import '../../repositories/daily_log_repository.dart';
import '../../repositories/event_repository.dart';
import '../../repositories/goal_repository.dart';
import '../../repositories/habit_repository.dart';
import '../../repositories/nivora_user_repository.dart';
import '../../services/haptics.dart';
import '../../services/insights_service.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import 'home_screen.dart';
import 'insights_screen.dart';

class NivoraShell extends StatefulWidget {
  const NivoraShell({
    super.key,
    required this.onSignOut,
    required this.userRepository,
    required this.habitRepository,
    required this.eventRepository,
    required this.goalRepository,
    required this.dailyLogRepository,
    required this.insightsService,
    this.initialIndex = 0,
  });

  final Future<void> Function() onSignOut;
  final NivoraUserRepository userRepository;
  final HabitRepository habitRepository;
  final EventRepository eventRepository;
  final GoalRepository goalRepository;
  final DailyLogRepository dailyLogRepository;
  final InsightsService insightsService;
  final int initialIndex;

  @override
  State<NivoraShell> createState() => _NivoraShellState();
}

class _NivoraShellState extends State<NivoraShell> {
  late int _currentIndex = widget.initialIndex.clamp(0, 1);

  late final List<Widget> _screens = [
    HomeScreen(
      onSignOut: _handleSignOut,
      habitRepository: widget.habitRepository,
      eventRepository: widget.eventRepository,
      dailyLogRepository: widget.dailyLogRepository,
      userRepository: widget.userRepository,
    ),
    InsightsScreen(
      habitRepository: widget.habitRepository,
      goalRepository: widget.goalRepository,
      dailyLogRepository: widget.dailyLogRepository,
      insightsService: widget.insightsService,
    ),
  ];

  void _handleSignOut() {
    unawaited(widget.onSignOut());
  }

  void _setTab(int index) {
    if (index != _currentIndex) {
      Haptics.selection();
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _setTab,
      ),
    );
  }
}
