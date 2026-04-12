import 'package:flutter/material.dart';
// Make sure these paths match your folder structure
import 'core/theme/app_theme.dart';
import 'features/onboarding/onboarding_screen.dart';

void main() {
  runApp(const HazelJournalApp());
}

class HazelJournalApp extends StatelessWidget {
  const HazelJournalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Journal',
      debugShowCheckedModeBanner:
          false, 
      theme: AppTheme.cozyTheme,
      home: const OnboardingScreen(),
    );
  }
}
