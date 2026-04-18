import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../../features/home/home_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/diet/diet_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/journal/new_entry_screen.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final VoidCallback?
  onEntryAdded; // Allows the current screen to refresh if needed

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    this.onEntryAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // 1. THE FLOATING WHITE PILL
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLowest,
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: AppTheme.sunlightShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      context,
                      icon: Icons.home_filled,
                      label: 'Home',
                      index: 0,
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.calendar_today_rounded,
                      label: 'History',
                      index: 1,
                    ),
                    const SizedBox(
                      width: 56,
                    ), // The empty gap for the hovering button
                    _buildNavItem(
                      context,
                      icon: Icons.restaurant_outlined,
                      label: 'Diet',
                      index: 2,
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      index: 3,
                    ),
                  ],
                ),
              ),
            ),

            // 2. THE HOVERING ADD BUTTON
            Positioned(
              top: 5,
              child: SizedBox(
                height: 60,
                width: 60,
                child: FloatingActionButton(
                  backgroundColor: AppTheme.secondary,
                  elevation: 4,
                  shape: const CircleBorder(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewEntryScreen(),
                      ),
                    ).then((_) {
                      // Triggers the refresh function if the screen provided one
                      if (onEntryAdded != null) {
                        onEntryAdded!();
                      }
                    });
                  },
                  child: const Icon(Icons.add, size: 32, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isActive = index == currentIndex;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (index == currentIndex)
          return; // Don't navigate if we are already on this tab!

        Widget nextScreen;
        switch (index) {
          case 0:
            nextScreen = const HomeScreen();
            break;
          case 1:
            nextScreen = const HistoryScreen();
            break;
          case 2:
            nextScreen = const DietScreen();
            break;
          case 3:
            nextScreen = const SettingsScreen();
            break;
          default:
            nextScreen = const HomeScreen();
        }

        // Swaps the screen instantly without a sliding animation
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => nextScreen,
            transitionDuration: Duration.zero,
          ),
        );
      },
      child: SizedBox(
        width: 54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isActive ? 26 : 24,
              color: isActive ? AppTheme.secondary : AppTheme.outline,
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  color: AppTheme.secondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
