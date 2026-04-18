import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 24,
                bottom: 24,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, size: 28),
                    color: AppTheme.textMain,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Notifications",
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 20),
                  ),
                ],
              ),
            ),

            // --- EMPTY STATE ---
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLow,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_paused_outlined,
                        size: 48,
                        color: AppTheme.textVariant.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "All caught up!",
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Your sanctuary is peaceful right now.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textVariant,
                      ),
                    ),
                    const SizedBox(height: 80), // Offset slightly above center
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
