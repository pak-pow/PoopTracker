import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/journal_entry.dart';
import '../../data/services/csv_service.dart';
import '../home/home_screen.dart';
import '../journal/new_entry_screen.dart';
import '../settings/settings_screen.dart';
import '../../core/widgets/custom_bottom_nav.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<JournalEntry> _dayEntries = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEntriesForDay(_focusedDay);
  }

  Future<void> _loadEntriesForDay(DateTime day) async {
    setState(() => _isLoading = true);
    final entries = await CsvService().getEntriesForDay(day);
    setState(() {
      _dayEntries = entries;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP APP BAR ---
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 24,
                right: 24,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
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

            // --- CALENDAR SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                onFormatChanged: (format) =>
                    setState(() => _calendarFormat = format),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _loadEntriesForDay(selectedDay);
                },
                onPageChanged: (focusedDay) =>
                    setState(() => _focusedDay = focusedDay),

                // Custom Header
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: false,
                  leftChevronIcon: const Icon(
                    Icons.chevron_left,
                    color: AppTheme.textVariant,
                  ),
                  rightChevronIcon: const Icon(
                    Icons.chevron_right,
                    color: AppTheme.textVariant,
                  ),
                  titleTextStyle: Theme.of(context).textTheme.displayMedium!
                      .copyWith(fontSize: 20, color: AppTheme.primary),
                ),

                // Calendar Styling to match Figma
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: AppTheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryContainer,
                      width: 2,
                    ),
                  ),
                  todayTextStyle: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  defaultTextStyle: TextStyle(
                    color: AppTheme.textMain,
                    fontWeight: FontWeight.w600,
                  ),
                  weekendTextStyle: TextStyle(
                    color: AppTheme.textMain.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),
                  outsideTextStyle: TextStyle(
                    color: AppTheme.textVariant.withOpacity(0.3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: Theme.of(context).textTheme.labelSmall!
                      .copyWith(color: AppTheme.textVariant.withOpacity(0.6)),
                  weekendStyle: Theme.of(context).textTheme.labelSmall!
                      .copyWith(color: AppTheme.textVariant.withOpacity(0.6)),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Divider(color: AppTheme.outline, thickness: 0.5),
            ),

            // --- ENTRIES LIST ---
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryContainer,
                      ),
                    )
                  : _dayEntries.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.spa_outlined,
                            size: 48,
                            color: AppTheme.textVariant.withOpacity(0.2),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No entries for this day",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppTheme.textVariant.withOpacity(0.5),
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 100,
                      ),
                      itemCount: _dayEntries.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  "PAST ENTRIES",
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(color: AppTheme.secondary),
                                ),
                                const Spacer(),
                                Text(
                                  DateFormat('MMM d')
                                      .format(_selectedDay ?? DateTime.now())
                                      .toUpperCase(),
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          );
                        }

                        final entry = _dayEntries[index - 1];
                        return _buildEntryCard(entry);
                      },
                    ),
            ),
          ],
        ),
      ),

      // --- NEW 4-BUTTON BOTTOM NAVIGATION ---
      extendBody: true,
      bottomNavigationBar: const CustomBottomNav(
        currentIndex: 1,
      ), // 1 highlights History!
    );
  }

  Widget _buildEntryCard(JournalEntry entry) {
    // Determine Emoji and Severity Pill based on the Type
    String emoji = "🍌";
    String severity = "NORMAL";
    Color severityColor = AppTheme.primary;
    Color severityBg = AppTheme.primaryContainer.withOpacity(0.2);

    if (entry.type.contains("Type 1") ||
        entry.type.contains("Type 2") ||
        entry.type.contains("Type 3")) {
      emoji = entry.type.contains("Type 1")
          ? "🪨"
          : (entry.type.contains("Type 2") ? "🥜" : "🪵");
      if (entry.discomfort > 3) {
        severity = "MILD PAIN";
        severityColor = AppTheme.secondary;
        severityBg = AppTheme.secondaryContainer.withOpacity(0.2);
      }
    } else if (entry.type.contains("Type 5") ||
        entry.type.contains("Type 6") ||
        entry.type.contains("Type 7")) {
      emoji = entry.type.contains("Type 5")
          ? "☁️"
          : (entry.type.contains("Type 6") ? "💧" : "🌊");
      if (entry.discomfort > 3) {
        severity = "DISCOMFORT";
        severityColor = AppTheme.secondary;
        severityBg = AppTheme.secondaryContainer.withOpacity(0.2);
      }
    }

    return Dismissible(
      key: Key(entry.date.toIso8601String() + entry.notes),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24.0),
        decoration: BoxDecoration(
          color: Colors.red.shade300,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) async {
        await CsvService().deleteEntry(entry);
        _loadEntriesForDay(_selectedDay ?? DateTime.now());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLowest,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppTheme.sunlightShadow,
          border: Border.all(color: AppTheme.outline.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.type,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('hh:mm a').format(entry.date),
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: severityBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    severity,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: severityColor,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
