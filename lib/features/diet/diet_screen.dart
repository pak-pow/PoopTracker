import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart';
import '../history/history_screen.dart';
import '../journal/new_entry_screen.dart';
import '../settings/settings_screen.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  int _waterGlasses = 3; // Mock starting data

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
                        "Organic Journal",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primary,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- SCROLLABLE CONTENT ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Diet & Hydration",
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(fontSize: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Track what fuels your body and affects your gut.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),

                    // --- WATER TRACKER CARD ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
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
                                "DAILY WATER",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              Text(
                                "$_waterGlasses / 8 Glasses",
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: Colors.blue.shade400),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(8, (index) {
                              bool isFilled = index < _waterGlasses;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _waterGlasses = index + 1;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 32,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isFilled
                                        ? Colors.blue.shade100
                                        : AppTheme.surfaceLow,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isFilled
                                          ? Colors.blue.shade300
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.water_drop_rounded,
                                    size: 20,
                                    color: isFilled
                                        ? Colors.blue.shade400
                                        : AppTheme.outline.withOpacity(0.3),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- MEALS SECTION ---
                    Text(
                      "TODAY'S MEALS",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 16),

                    _buildMealCard(
                      "Breakfast",
                      "Oatmeal with berries and a dash of cinnamon.",
                      "🔥 320 kcal",
                      true,
                    ),
                    const SizedBox(height: 12),
                    _buildMealCard("Lunch", "Log your meal...", "", false),
                    const SizedBox(height: 12),
                    _buildMealCard("Dinner", "Log your meal...", "", false),
                    const SizedBox(height: 12),
                    _buildMealCard("Snacks", "Log your snacks...", "", false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // --- MATCHING NOTCHED BOTTOM BAR ---
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 32),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          backgroundColor: AppTheme.secondary,
          elevation: 6,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewEntryScreen()),
            );
          },
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppTheme.surfaceLowest,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        elevation: 20,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_filled,
                label: 'Home',
                index: 0,
                currentIndex: 2,
              ), // Index 2 is Diet!
              _buildNavItem(
                icon: Icons.calendar_today_rounded,
                label: 'History',
                index: 1,
                currentIndex: 2,
              ),
              const SizedBox(width: 48), // Space for floating button
              _buildNavItem(
                icon: Icons.restaurant_outlined,
                label: 'Diet',
                index: 2,
                currentIndex: 2,
              ),
              _buildNavItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                index: 3,
                currentIndex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealCard(
    String title,
    String subtitle,
    String calories,
    bool isLogged,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLogged ? AppTheme.surfaceLowest : AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLogged ? AppTheme.primaryContainer : Colors.transparent,
        ),
        boxShadow: isLogged ? AppTheme.sunlightShadow : [],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isLogged
                  ? AppTheme.primaryContainer.withOpacity(0.3)
                  : AppTheme.surfaceLowest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLogged ? Icons.restaurant : Icons.add_rounded,
              color: isLogged
                  ? AppTheme.primary
                  : AppTheme.textVariant.withOpacity(0.5),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    color: isLogged
                        ? AppTheme.textMain
                        : AppTheme.textVariant.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          if (isLogged)
            Text(
              calories,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppTheme.secondary),
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
  }) {
    bool isActive = index == currentIndex;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const HomeScreen(),
              transitionDuration: Duration.zero,
            ),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const HistoryScreen(),
              transitionDuration: Duration.zero,
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
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isActive ? 28 : 26,
              color: isActive ? AppTheme.secondary : AppTheme.outline,
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 10,
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
