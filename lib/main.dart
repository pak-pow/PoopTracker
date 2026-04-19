import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'data/services/notification_service.dart';

import 'features/onboarding/onboarding_screen.dart';
import 'features/home/home_screen.dart';

import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await NotificationService().init();
  } catch (e) {
    debugPrint('Failed to initialize NotificationService: $e');
  }

  bool isFirstLaunch = true;
  try {
    final prefs = await SharedPreferences.getInstance();

    final remindersEnabled = prefs.getBool('remindersEnabled') ?? true;
    if (remindersEnabled) {
      final hour = prefs.getInt('reminderHour') ?? 20;
      final min = prefs.getInt('reminderMinute') ?? 30;
      try {
        await NotificationService().scheduleDailyReminder(
          TimeOfDay(hour: hour, minute: min),
        );
      } catch (e) {
        debugPrint('Failed to schedule daily reminder: $e');
      }
    } else {
      await NotificationService().cancelAllNotifications();
    }

    isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
  } catch (e) {
    debugPrint('Failed to initialize SharedPreferences: $e');
  }

  runApp(HazelJournalApp(isFirstLaunch: isFirstLaunch));
}

class HazelJournalApp extends StatelessWidget {
  final bool isFirstLaunch;

  const HazelJournalApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organic Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.organicTheme,
      home: isFirstLaunch ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}
