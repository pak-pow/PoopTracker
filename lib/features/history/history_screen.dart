import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // --- THEME COLORS ---
  final Color bgCream = const Color(0xFFFDFCF5);
  final Color textBrown = const Color(0xFF3A3A3A);
  final Color accentGreen = const Color(0xFFA3B18A);
  final Color accentPeach = const Color(0xFFE29578);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP CALENDAR SECTION ---
            Container(
              padding: const EdgeInsets.only(
                top: 16,
                left: 24,
                right: 24,
                bottom: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Journal",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textBrown,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: bgCream,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.chevron_left,
                              color: accentGreen,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "April 2026",
                              style: TextStyle(
                                color: textBrown,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.chevron_right,
                              color: accentGreen,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Days of Week
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ["S", "M", "T", "W", "T", "F", "S"].map((day) {
                      return SizedBox(
                        width: 32,
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textBrown.withOpacity(0.4),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Mock Calendar Grid (Matching your Figma)
                  _buildMockCalendarRow(
                    ["29", "30", "31", "1", "2", "3", "4"],
                    isFaded: [true, true, true, false, false, false, false],
                  ),
                  _buildMockCalendarRow(
                    ["5", "6", "7", "8", "9", "10", "11"],
                    hasEntry: [false, false, true, true, false, true, false],
                    selectedIndex: 6,
                  ),
                  _buildMockCalendarRow([
                    "12",
                    "13",
                    "14",
                    "15",
                    "16",
                    "17",
                    "18",
                  ]),
                  _buildMockCalendarRow([
                    "19",
                    "20",
                    "21",
                    "22",
                    "23",
                    "24",
                    "25",
                  ]),
                  _buildMockCalendarRow(
                    ["26", "27", "28", "29", "30", "1", "2"],
                    isFaded: [false, false, false, false, false, true, true],
                  ),
                ],
              ),
            ),

            // --- RECENT ENTRIES LIST ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    "RECENT ENTRIES",
                    style: TextStyle(
                      color: accentGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Entry Card 1
                  _buildEntryCard(
                    icon: Icons.sentiment_satisfied_alt,
                    title: "Smooth",
                    time: "08:30 AM",
                    notes: "Feeling great today, hydrated well yesterday.",
                    calories: "450 kcal",
                    iconColor: accentGreen,
                  ),
                  const SizedBox(height: 12),

                  // Entry Card 2
                  _buildEntryCard(
                    icon: Icons.water_drop_outlined,
                    title: "Loose",
                    time: "Yesterday",
                    notes: "Maybe too much coffee this morning.",
                    calories: "320 kcal",
                    iconColor: accentPeach,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // --- BOTTOM NAVIGATION (Identical to Home, but Index 1 selected) ---
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
            currentIndex: 1, // JOURNAL is selected
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
              // Index 2 will go to settings later
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

  // --- HELPER WIDGETS ---

  // Builds a row of 7 days for our UI mock calendar
  Widget _buildMockCalendarRow(
    List<String> days, {
    List<bool>? isFaded,
    List<bool>? hasEntry,
    int selectedIndex = -1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          bool faded = isFaded != null ? isFaded[index] : false;
          bool entry = hasEntry != null ? hasEntry[index] : false;
          bool selected = index == selectedIndex;

          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: selected ? accentPeach : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  days[index],
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : (faded ? textBrown.withOpacity(0.2) : textBrown),
                    fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
                if (entry && !selected)
                  Positioned(
                    bottom: 2,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: accentGreen.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Builds the beautiful entry cards with the new Calorie Badge
  Widget _buildEntryCard({
    required IconData icon,
    required String title,
    required String time,
    required String notes,
    required String calories,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Icon Profile
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgCream, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: textBrown,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: textBrown.withOpacity(0.4),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notes,
                  style: TextStyle(
                    color: textBrown.withOpacity(0.7),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                // NEW CALORIE BADGE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accentPeach.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_fire_department_outlined,
                        size: 14,
                        color: accentPeach,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        calories,
                        style: TextStyle(
                          color: accentPeach,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
