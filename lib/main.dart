import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'data/services/notification_service.dart';

import 'features/onboarding/onboarding_screen.dart';
import 'features/home/home_screen.dart';

import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().init();
  
  final prefs = await SharedPreferences.getInstance();
  
  final remindersEnabled = prefs.getBool('remindersEnabled') ?? true;
  if (remindersEnabled) {
    final hour = prefs.getInt('reminderHour') ?? 20;
    final min = prefs.getInt('reminderMinute') ?? 30;
    await NotificationService().scheduleDailyReminder(
      TimeOfDay(hour: hour, minute: min),
    );
  } else {
    await NotificationService().cancelAllNotifications();
  }

  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
  runApp(HazelJournalApp(isFirstLaunch: isFirstLaunch));
}

class HazelJournalApp extends StatelessWidget {
  final bool isFirstLaunch;

  const HazelJournalApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Journal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.organicTheme,
      home: isFirstLaunch ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}
