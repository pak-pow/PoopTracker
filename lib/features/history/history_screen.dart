import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Used to format the Month/Year text
import '../home/home_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Calendar State
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

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
                left: 16,
                right: 16,
                bottom: 16,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      "Journal",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textBrown,
                      ),
                    ),
                  ),

                  // The Real Interactive Calendar
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    // Styling the Header to match your Figma
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: accentGreen,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: accentGreen,
                      ),
                      titleTextStyle: TextStyle(
                        color: textBrown,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      headerPadding: const EdgeInsets.only(bottom: 16.0),
                    ),
                    // Styling the Days
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: accentPeach,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: accentGreen.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: TextStyle(
                        color: textBrown,
                        fontWeight: FontWeight.w600,
                      ),
                      weekendTextStyle: TextStyle(
                        color: textBrown.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                      ),
                      outsideTextStyle: TextStyle(
                        color: textBrown.withOpacity(0.2),
                        fontWeight: FontWeight.w600,
                      ),
                      todayTextStyle: TextStyle(
                        color: textBrown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Styling the Mon, Tue, Wed row
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: textBrown.withOpacity(0.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      weekendStyle: TextStyle(
                        color: textBrown.withOpacity(0.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
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
                    "ENTRIES FOR ${DateFormat('MMM d, yyyy').format(_selectedDay ?? DateTime.now()).toUpperCase()}",
                    style: TextStyle(
                      color: accentGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dummy Entry Card 1
                  _buildEntryCard(
                    icon: Icons.sentiment_satisfied_alt,
                    title: "Smooth",
                    time: "08:30 AM",
                    notes: "Feeling great today, hydrated well yesterday.",
                    calories: "450 kcal",
                    iconColor: accentGreen,
                  ),
                  const SizedBox(height: 12),

                  // Dummy Entry Card 2
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
            currentIndex: 1,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const HomeScreen(),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgCream, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
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
