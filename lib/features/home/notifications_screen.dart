import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/notification_service.dart';

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

            // --- LIST STATE ---
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: NotificationService().getPendingNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
                  }
                  
                  final pending = snapshot.data ?? [];
                  
                  if (pending.isEmpty) {
                    return Center(
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
                            "You have no upcoming scheduled reminders.",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textVariant,
                            ),
                          ),
                          const SizedBox(height: 80), 
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemCount: pending.length,
                    itemBuilder: (context, index) {
                      final req = pending[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.outline.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.notifications_active, color: AppTheme.primary),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    req.title ?? "Unknown Notification",
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    req.body ?? "No body",
                                    style: TextStyle(color: AppTheme.textVariant, fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.secondary.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      "SCHEDULED NATIVELY",
                                      style: TextStyle(fontSize: 10, color: AppTheme.secondary, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
