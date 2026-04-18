import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/csv_service.dart';
import '../journal/new_entry_screen.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _weeklyRhythm = 0;
  String _nickname = 'Hazel';

  @override
  void initState() {
    super.initState();
    _loadNickname();
    _loadRhythm();
  }

  Future<void> _loadNickname() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nickname = prefs.getString('nickname') ?? 'Hazel';
    });
  }

  Future<void> _loadRhythm() async {
    final count = await CsvService().getWeeklyRhythmCount();
    setState(() {
      _weeklyRhythm = count;
    });
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // --- MAIN SCROLLABLE CONTENT ---
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 80,
                left: 24,
                right: 24,
                bottom: 120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- GREETING ---
                  Text(
                    "$_greeting, $_nickname! 👋",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 26,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ready for your daily reflection?",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 32),

                  // --- WEEKLY RHYTHM CARD ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLow,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "THIS WEEK'S RHYTHM",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            Text(
                              "$_weeklyRhythm/7 Days",
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: AppTheme.secondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                              .asMap()
                              .entries
                              .map((entry) {
                                // Simple logic to highlight days based on rhythm count (just for visual mockup)
                                bool isActive = entry.key < _weeklyRhythm;
                                return Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? AppTheme.secondary
                                        : AppTheme.outline.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    entry.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: isActive
                                              ? Colors.white
                                              : AppTheme.textVariant
                                                    .withOpacity(0.5),
                                          fontSize: 14,
                                        ),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- LOG TODAY BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewEntryScreen(),
                          ),
                        );
                        _loadRhythm();
                      },
                      icon: const Icon(Icons.add_circle, size: 24),
                      label: const Text(
                        "Log Today",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        shadowColor: AppTheme.secondary.withOpacity(0.4),
                        elevation: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- RECENT ENTRY PREVIEW ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Recent Entry",
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 18),
                      ),
                      Text(
                        "VIEW HISTORY",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLowest,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppTheme.sunlightShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "YESTERDAY, 8:45 PM",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryContainer.withOpacity(
                                  0.2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "LOGGED",
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppTheme.primary,
                                      fontSize: 9,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              "🌿",
                              style: TextStyle(fontSize: 32),
                            ), // Placeholder icon
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Great Day",
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontSize: 16),
                                ),
                                Text(
                                  "Feeling healthy and light",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- TOP APP BAR (FROSTED GLASS) ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100, // Covers status bar + app bar
              padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
              decoration: BoxDecoration(
                color: AppTheme.background.withOpacity(0.9),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // --- NEW CAPYBARA LOGO ---
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          'assets/logo_capybara.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "The Organic Journal",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primary,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.notifications_outlined, color: AppTheme.primary),
                ],
              ),
            ),
          ),
        ],
      ),

      // --- NEW 4-BUTTON BOTTOM NAVIGATION ---
      extendBody: true, // Allows content to scroll behind the floating nav
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLowest,
          borderRadius: BorderRadius.circular(32),
          boxShadow: AppTheme.sunlightShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BottomNavigationBar(
            backgroundColor: AppTheme.surfaceLowest,
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: AppTheme.secondary,
            unselectedItemColor: AppTheme.outline,
            selectedLabelStyle: Theme.of(context).textTheme.labelSmall
                ?.copyWith(fontSize: 10, color: AppTheme.secondary),
            unselectedLabelStyle: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontSize: 10),
            elevation: 0,
            onTap: (index) {
              if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const HistoryScreen(),
                    transitionDuration: Duration.zero,
                  ),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewEntryScreen(),
                  ),
                );
              } else if (index == 3) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const SettingsScreen(),
                    transitionDuration: Duration.zero,
                  ),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_rounded),
                label: 'HISTORY',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline, size: 28),
                label: 'ENTRY',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: 'SETTINGS',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
