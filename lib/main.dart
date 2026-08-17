import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'repositories/daily_log_repository.dart';
import 'repositories/event_repository.dart';
import 'repositories/goal_repository.dart';
import 'repositories/habit_repository.dart';
import 'repositories/nivora_user_repository.dart';
import 'firebase_options.dart';
import 'screens/app/nivora_shell.dart';
import 'screens/auth/login_screen.dart';
import 'services/auth_service.dart';
import 'services/insights_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authService = AuthService();
  final userRepository = NivoraUserRepository();
  final habitRepository = HabitRepository();
  final eventRepository = EventRepository();
  final goalRepository = GoalRepository();
  final dailyLogRepository = DailyLogRepository();
  final insightsService = InsightsService();

  await authService.initializeGoogleSignIn();

  runApp(
    NivoraApp(
      authStateChanges: authService.authStateChanges,
      onSignOut: authService.signOut,
      userRepository: userRepository,
      habitRepository: habitRepository,
      eventRepository: eventRepository,
      goalRepository: goalRepository,
      dailyLogRepository: dailyLogRepository,
      insightsService: insightsService,
    ),
  );
}

class NivoraApp extends StatelessWidget {
  const NivoraApp({
    super.key,
    this.authStateChanges,
    this.onSignOut,
    this.userRepository,
    this.habitRepository,
    this.eventRepository,
    this.goalRepository,
    this.dailyLogRepository,
    this.insightsService,
  });

  final Stream<User?>? authStateChanges;
  final Future<void> Function()? onSignOut;
  final NivoraUserRepository? userRepository;
  final HabitRepository? habitRepository;
  final EventRepository? eventRepository;
  final GoalRepository? goalRepository;
  final DailyLogRepository? dailyLogRepository;
  final InsightsService? insightsService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NIVORA',
      theme: AppTheme.light(),
      home: StreamBuilder(
        stream: authStateChanges ?? AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return NivoraShell(
              onSignOut: onSignOut ?? AuthService().signOut,
              userRepository: userRepository ?? NivoraUserRepository(),
              habitRepository: habitRepository ?? HabitRepository(),
              eventRepository: eventRepository ?? EventRepository(),
              goalRepository: goalRepository ?? GoalRepository(),
              dailyLogRepository: dailyLogRepository ?? DailyLogRepository(),
              insightsService: insightsService ?? const InsightsService(),
            );
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
