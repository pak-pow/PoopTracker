import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/journal_entry.dart';
import '../../data/services/csv_service.dart';
import '../journal/new_entry_screen.dart';
import '../history/history_screen.dart';
import 'notifications_screen.dart';
import '../../core/widgets/custom_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _streakCount = 0;
  String _nickname = 'Vincent';
  JournalEntry? _recentEntry;

  // NEW: A map to hold the meals linked to the recent entry's date
  Map<String, String> _recentMeals = {};
  int _recentTotalCalories = 0;

  @override
  void initState() {
    super.initState();
    _loadNickname();
    _loadDashboardData();
  }

  Future<void> _loadNickname() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _nickname = prefs.getString('nickname') ?? 'Vincent';
    });
  }

  Future<void> _loadDashboardData() async {
    final count = await CsvService().getCurrentStreak();
    final recent = await CsvService().getMostRecentEntry();
    final prefs = await SharedPreferences.getInstance();

    Map<String, String> meals = {};
    int totalCals = 0;

    // NEW: If we have a recent entry, fetch the diet logs for that exact date!
    if (recent != null) {
      String dateKey = DateFormat('yyyy-MM-dd').format(recent.date);
      for (String meal in ['Breakfast', 'Lunch', 'Dinner', 'Snacks']) {
        meals[meal] = prefs.getString('meal_${dateKey}_${meal}_desc') ?? '';
        String calsStr = prefs.getString('meal_${dateKey}_${meal}_cals') ?? '';
        if (calsStr.isNotEmpty) {
          totalCals += int.tryParse(calsStr) ?? 0;
        }
      }
    }

    if (!mounted) return;
    setState(() {
      _streakCount = count;
      _recentEntry = recent;
      _recentMeals = meals;
      _recentTotalCalories = totalCals;
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
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$_greeting, $_nickname! 👋",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 26,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Ready for your daily reflection?",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 24),

                  // --- HYBRID STREAK & WEEKLY RHYTHM CARD ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLow,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppTheme.secondary.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "🔥",
                                style: TextStyle(fontSize: 28),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CURRENT STREAK",
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "$_streakCount Days",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        color: AppTheme.secondary,
                                        fontSize: 24,
                                      ),
                                ),
                              ],
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
                                bool isActive =
                                    entry.key <
                                    (_streakCount > 7 ? 7 : _streakCount);
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
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewEntryScreen(),
                          ),
                        );
                        _loadDashboardData();
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
                        elevation: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

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
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const HistoryScreen(),
                            transitionDuration: Duration.zero,
                          ),
                        ),
                        child: Text(
                          "VIEW HISTORY",
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppTheme.secondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _recentEntry == null
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceLowest,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: AppTheme.sunlightShadow,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.spa_outlined,
                                color: AppTheme.textVariant.withOpacity(0.3),
                                size: 32,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "No logs yet. You're doing great!",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        )
                      : _buildRecentEntryCard(_recentEntry!),
                ],
              ),
            ),
          ),

          // --- FIXED TOP BAR ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              padding: const EdgeInsets.only(top: 40, left: 24, right: 16),
              decoration: BoxDecoration(
                color: AppTheme.background.withOpacity(0.95),
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
                        "Organic Journal",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primary,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    color: AppTheme.primary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      extendBody: true,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
        onEntryAdded: _loadDashboardData,
      ),
    );
  }

  Widget _buildRecentEntryCard(JournalEntry entry) {
    String emoji = "🍌";
    String severity = "LOGGED";
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

    String timeStr = DateFormat('h:mm a').format(entry.date);
    String dateStr = DateFormat('MMM d').format(entry.date).toUpperCase();

    bool hasMeals = _recentMeals.values.any((meal) => meal.isNotEmpty);

    return Container(
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
                "$dateStr, $timeStr",
                style: Theme.of(context).textTheme.labelSmall,
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
          const SizedBox(height: 16),

          // The main Journal output
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 26)),
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
                    const SizedBox(height: 4),
                    Text(
                      entry.notes.isNotEmpty ? entry.notes : "No notes added.",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // NEW: The linked Diet Log!
          if (hasMeals) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(
                color: AppTheme.surfaceLow,
                thickness: 2,
                height: 2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "DIET LOG FOR THIS DAY",
                  style: TextStyle(
                    fontFamily: 'JakartaSans',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textVariant,
                    letterSpacing: 1.2,
                  ),
                ),
                if (_recentTotalCalories > 0)
                  Text(
                    "🔥 $_recentTotalCalories kcal total",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.secondary,
                          fontSize: 10,
                        ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_recentMeals['Breakfast']!.isNotEmpty)
              _buildMiniMealRow("Breakfast", _recentMeals['Breakfast']!),
            if (_recentMeals['Lunch']!.isNotEmpty)
              _buildMiniMealRow("Lunch", _recentMeals['Lunch']!),
            if (_recentMeals['Dinner']!.isNotEmpty)
              _buildMiniMealRow("Dinner", _recentMeals['Dinner']!),
            if (_recentMeals['Snacks']!.isNotEmpty)
              _buildMiniMealRow("Snacks", _recentMeals['Snacks']!),
          ],
        ],
      ),
    );
  }

  // A tiny helper widget to make the linked meals look beautiful inside the card
  Widget _buildMiniMealRow(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.circle, size: 6, color: AppTheme.secondary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 13, height: 1.3),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMain,
                    ),
                  ),
                  TextSpan(
                    text: desc,
                    style: const TextStyle(color: AppTheme.textVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
