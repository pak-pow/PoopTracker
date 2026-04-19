import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_bottom_nav.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  int _waterGlasses = 0;

  final Map<String, Map<String, String>> _meals = {
    'Breakfast': {'desc': '', 'cals': ''},
    'Lunch': {'desc': '', 'cals': ''},
    'Dinner': {'desc': '', 'cals': ''},
    'Snacks': {'desc': '', 'cals': ''},
  };

  String get _todayKey => DateFormat('yyyy-MM-dd').format(DateTime.now());

  // NEW: Calculates the total calories for the day automatically!
  int get _totalCalories {
    int total = 0;
    for (var meal in _meals.values) {
      if (meal['cals']!.isNotEmpty) {
        total += int.tryParse(meal['cals']!) ?? 0;
      }
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    _loadDietData();
  }

  Future<void> _loadDietData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterGlasses = prefs.getInt('water_$_todayKey') ?? 0;

      for (String meal in _meals.keys) {
        _meals[meal]!['desc'] =
            prefs.getString('meal_${_todayKey}_${meal}_desc') ?? '';
        _meals[meal]!['cals'] =
            prefs.getString('meal_${_todayKey}_${meal}_cals') ?? '';
      }
    });
  }

  Future<void> _updateWater(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('water_$_todayKey', count);
    setState(() {
      _waterGlasses = count;
    });
  }

  Future<void> _showMealDialog(String mealType) async {
    final TextEditingController descController = TextEditingController(
      text: _meals[mealType]!['desc'],
    );
    final TextEditingController calsController = TextEditingController(
      text: _meals[mealType]!['cals'],
    );

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLowest,
              borderRadius: BorderRadius.circular(36),
              boxShadow: AppTheme.sunlightShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Log $mealType",
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(fontSize: 28, color: AppTheme.primary),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppTheme.outline,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "What fueled you today?",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),

                TextField(
                  controller: descController,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: "E.g. Oatmeal with berries...",
                    hintStyle: TextStyle(
                      color: AppTheme.textVariant.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: AppTheme.surfaceLow,
                    contentPadding: const EdgeInsets.all(20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: calsController,
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: "Estimated Calories (Optional)",
                    hintStyle: TextStyle(
                      color: AppTheme.textVariant.withOpacity(0.5),
                      fontWeight: FontWeight.normal,
                    ),
                    prefixIcon: const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppTheme.secondary,
                    ),
                    filled: true,
                    fillColor: AppTheme.surfaceLow,
                    contentPadding: const EdgeInsets.all(20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      shadowColor: AppTheme.secondary.withOpacity(0.4),
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(
                        'meal_${_todayKey}_${mealType}_desc',
                        descController.text.trim(),
                      );
                      await prefs.setString(
                        'meal_${_todayKey}_${mealType}_cals',
                        calsController.text.trim(),
                      );

                      setState(() {
                        _meals[mealType]!['desc'] = descController.text.trim();
                        _meals[mealType]!['cals'] = calsController.text.trim();
                      });

                      if (mounted) Navigator.pop(context);
                    },
                    child: const Text(
                      "Save Meal",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 24,
                right: 24,
                bottom: 8,
              ),
              child: Row(
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
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: 120,
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
                                  if (_waterGlasses == index + 1) {
                                    _updateWater(index);
                                  } else {
                                    _updateWater(index + 1);
                                  }
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

                    // --- DYNAMIC TOTAL CALORIES HEADER ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "TODAY'S MEALS",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        if (_totalCalories > 0)
                          Row(
                            children: [
                              const Icon(Icons.local_fire_department, size: 14, color: AppTheme.secondary),
                              const SizedBox(width: 4),
                              Text(
                                "$_totalCalories kcal total",
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppTheme.secondary,
                                      fontSize: 10,
                                    ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildMealCard("Breakfast"),
                    const SizedBox(height: 12),
                    _buildMealCard("Lunch"),
                    const SizedBox(height: 12),
                    _buildMealCard("Dinner"),
                    const SizedBox(height: 12),
                    _buildMealCard("Snacks"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }

  Widget _buildMealCard(String mealType) {
    String desc = _meals[mealType]!['desc']!;
    String cals = _meals[mealType]!['cals']!;
    bool isLogged = desc.isNotEmpty;

    return GestureDetector(
      onTap: () => _showMealDialog(mealType),
      child: Container(
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
                    mealType,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isLogged ? desc : "Tap to log your meal...",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      color: isLogged
                          ? AppTheme.textMain
                          : AppTheme.textVariant.withOpacity(0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isLogged && cals.isNotEmpty)
              Row(
                children: [
                   const Icon(Icons.local_fire_department, size: 14, color: AppTheme.secondary),
                   const SizedBox(width: 4),
                   Text(
                    "$cals kcal",
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: AppTheme.secondary),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
