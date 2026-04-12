import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'features/onboarding/onboarding_screen.dart';
import 'features/home/home_screen.dart';

import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
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
      theme: AppTheme.cozyTheme,
      home: isFirstLaunch ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}
