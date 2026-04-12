import 'package:flutter/material.dart';
import '../../data/models/journal_entry.dart';
import '../../data/services/csv_service.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({Key? key}) : super(key: key);

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  // --- STATE VARIABLES ---
  String _selectedType = 'Smooth & Soft';
  double _discomfortLevel = 1.0;

  // Tag Management
  final List<String> _availableTags = [
    'Hydrated',
    'High Fiber',
    'Stressed',
    'Travel',
    'Sick',
    'Caffeine',
  ];
  final Set<String> _selectedTags = {};

  // Text Controllers
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // --- THEME COLORS ---
  final Color bgCream = const Color(0xFFFDFCF5);
  final Color textBrown = const Color(0xFF3A3A3A);
  final Color accentGreen = const Color(0xFFA3B18A);
  final Color accentPeach = const Color(0xFFE29578);
  final Color softPink = const Color(0xFFFFDAB9); // For the 'Loose' selection

  @override
  void dispose() {
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      appBar: AppBar(
        backgroundColor: bgCream,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: textBrown, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "New Journal Entry",
          style: TextStyle(
            color: textBrown,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HOW WAS IT? (Type Selection)
              _buildSectionHeader("HOW WAS IT?"),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTypeCard(
                    "Hard & Dry",
                    Icons.sentiment_very_dissatisfied,
                  ),
                  _buildTypeCard(
                    "Smooth & Soft",
                    Icons.sentiment_satisfied_alt,
                  ),
                  _buildTypeCard("Loose & Watery", Icons.water_drop_outlined),
                ],
              ),
              const SizedBox(height: 32),

              // 2. DISCOMFORT LEVEL
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: accentPeach.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader("DISCOMFORT LEVEL"),
                        Text(
                          "${_discomfortLevel.toInt()}/10",
                          style: TextStyle(
                            color: accentPeach,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: accentPeach,
                        inactiveTrackColor: bgCream,
                        thumbColor: Colors.white,
                        trackHeight: 8,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 12,
                          elevation: 4,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 24,
                        ),
                      ),
                      child: Slider(
                        value: _discomfortLevel,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        onChanged: (value) {
                          setState(() {
                            _discomfortLevel = value;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "None",
                          style: TextStyle(
                            color: textBrown.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Severe",
                          style: TextStyle(
                            color: textBrown.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 3. QUICK TAGS
              _buildSectionHeader("QUICK TAGS"),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: [
                  ..._availableTags.map((tag) => _buildTagChip(tag)),
                  // Add Tag Button
                  ActionChip(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: accentGreen.withOpacity(0.5),
                        style: BorderStyle.solid,
                      ),
                    ),
                    label: Text(
                      "+ Add Tag",
                      style: TextStyle(
                        color: accentGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      // TODO: Show dialog to add custom tag
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 4. NUTRITION
              _buildSectionHeader("NUTRITION (OPTIONAL)"),
              const SizedBox(height: 12),
              TextField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Estimated Calories (kcal)",
                  hintStyle: TextStyle(color: textBrown.withOpacity(0.3)),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: Icon(
                    Icons.apple,
                    color: accentPeach.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 5. OPTIONAL NOTES
              _buildSectionHeader("OPTIONAL NOTES"),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "How are you feeling today?",
                  hintStyle: TextStyle(color: textBrown.withOpacity(0.3)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 6. SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final newEntry = JournalEntry(
                      date: DateTime.now(),
                      type: _selectedType,
                      discomfort: _discomfortLevel,
                      tags: _selectedTags.toList(),
                      calories: _caloriesController.text.trim(),
                      notes: _notesController.text.trim(),
                    );
                    await CsvService().saveEntry(newEntry);

                    if (mounted) {
                      Navigator.pop(context);

                      // Optional: Show a cozy little success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("✨ Entry saved successfully!"),
                          backgroundColor: accentGreen,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.check_circle_outline, size: 24),
                  label: const Text(
                    "Save to Journal",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: accentGreen,
        fontWeight: FontWeight.bold,
        fontSize: 13,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTypeCard(String title, IconData icon) {
    bool isSelected = _selectedType == title;
    // Determine specific styling based on Figma design
    Color selectedColor = title == 'Loose & Watery'
        ? softPink
        : (title == 'Hard & Dry'
              ? accentPeach.withOpacity(0.2)
              : accentGreen.withOpacity(0.2));
    Color selectedBorder = title == 'Loose & Watery'
        ? accentPeach
        : (title == 'Hard & Dry' ? accentPeach : accentGreen);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: MediaQuery.of(context).size.width * 0.26,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? selectedBorder : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? textBrown : textBrown.withOpacity(0.4),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? textBrown : textBrown.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String label) {
    bool isSelected = _selectedTags.contains(label);
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : textBrown.withOpacity(0.7),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
      ),
      backgroundColor: Colors.white,
      selectedColor: accentGreen,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
      elevation: isSelected ? 2 : 0,
      shadowColor: accentGreen.withOpacity(0.3),
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedTags.add(label);
          } else {
            _selectedTags.remove(label);
          }
        });
      },
    );
  }
}
