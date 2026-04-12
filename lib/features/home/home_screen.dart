import 'package:flutter/material.dart';
import '../journal/new_entry_screen.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';
import '../../data/services/csv_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _weeklyRhythm = 0;
  String _nickname = 'Hazel'; // Default fallback

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

  // --- BUG FIX: DYNAMIC GREETING ---
  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    const Color bgCream = Color(0xFFFDFCF5);
    const Color textBrown = Color(0xFF3A3A3A);
    const Color accentGreen = Color(0xFFA3B18A);
    const Color accentPeach = Color(0xFFE29578);

    return Scaffold(
      backgroundColor: bgCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TOP GREETING ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$_greeting, $_nickname! ✨",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A3A3A),
                          ),
                          // Added this so if a name is too long, it wraps nicely instead of breaking!
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Ready to track your day?",
                          style: TextStyle(
                            fontSize: 14,
                            color: accentGreen.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/icon_navbar.png',
                    height: 32, // Changed from 48
                    width: 32, // Changed from 48
                  ), // Adds a tiny buffer between text and logo
                ],
              ),

              const Spacer(),

              // --- WEEKLY RHYTHM CARD ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: accentPeach.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Your Weekly Rhythm",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textBrown,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Circular Progress
                    SizedBox(
                      height: 140,
                      width: 140,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: _weeklyRhythm / 7,
                            strokeWidth: 12,
                            backgroundColor: bgCream,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              accentPeach,
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$_weeklyRhythm",
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: textBrown,
                                  height: 1.0,
                                ),
                              ),
                              const Text(
                                "DAYS",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: accentGreen,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // --- BUG FIX: NO MORE 0-DAY STREAK ---
                    _weeklyRhythm > 0
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: bgCream,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "🔥 $_weeklyRhythm-Day Streak! Keep it up.",
                              style: const TextStyle(
                                color: accentPeach,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: bgCream,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Start logging to build your streak! 🌱",
                              style: TextStyle(
                                color: accentGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                  ],
                ),
              ),

              const Spacer(),

              // --- PRIMARY ACTION BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // --- BUG FIX: AWAIT NEW ENTRY THEN RELOAD RHYTHM ---
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewEntryScreen(),
                      ),
                    );
                    _loadRhythm();
                  },
                  icon: const Icon(Icons.add, size: 28),
                  label: const Text(
                    "Log New Entry",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentPeach,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: accentPeach.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // --- BOTTOM NAVIGATION ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: 0,
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
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const SettingsScreen(),
                    transitionDuration: Duration.zero,
                  ),
                );
              }
            },
            selectedItemColor: accentPeach,
            unselectedItemColor: accentGreen.withOpacity(0.5),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(Icons.home_filled),
                ),
                label: 'Today',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(Icons.calendar_today_rounded),
                ),
                label: 'Journal',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(Icons.settings_outlined),
                ),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
