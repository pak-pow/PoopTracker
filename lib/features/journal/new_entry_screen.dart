import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/journal_entry.dart';
import '../../data/services/csv_service.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({Key? key}) : super(key: key);

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  // --- STATE VARIABLES ---
  String _selectedType = 'Type 4: Smooth';
  double _discomfortLevel = 1.0;
  bool _showAllTypes = false; // Controls the expand/collapse

  // The Full Official Bristol Stool Scale
  final List<Map<String, String>> _allStoolTypes = [
    {
      "title": "Type 1",
      "subtitle": "Separate hard lumps",
      "emoji": "🪨",
      "internal": "Type 1: Hard Lumps",
    },
    {
      "title": "Type 2",
      "subtitle": "Sausage-shaped, lumpy",
      "emoji": "🥜",
      "internal": "Type 2: Lumpy",
    },
    {
      "title": "Type 3",
      "subtitle": "Sausage with cracks",
      "emoji": "🪵",
      "internal": "Type 3: Cracked",
    },
    {
      "title": "Type 4",
      "subtitle": "Smooth, soft sausage",
      "emoji": "🍌",
      "internal": "Type 4: Smooth",
    },
    {
      "title": "Type 5",
      "subtitle": "Soft blobs, clear edges",
      "emoji": "☁️",
      "internal": "Type 5: Soft Blobs",
    },
    {
      "title": "Type 6",
      "subtitle": "Mushy, ragged edges",
      "emoji": "💧",
      "internal": "Type 6: Mushy",
    },
    {
      "title": "Type 7",
      "subtitle": "Liquid, no solid pieces",
      "emoji": "🌊",
      "internal": "Type 7: Liquid",
    },
  ];

  // Tag Management
  final List<String> _availableTags = [
    'Bloated',
    'Crampy',
    'Urgent',
    'Post-meal',
    'Nauseous',
    'Hydrated',
    'High Fiber',
  ];
  final Set<String> _selectedTags = {};

  // Text Controllers
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // --- ADD TAG DIALOG ---
  void _showAddTagDialog() {
    final TextEditingController tagController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          "Add Custom Tag",
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontSize: 20),
        ),
        content: TextField(
          controller: tagController,
          textCapitalization: TextCapitalization.words,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: "e.g. Spicy Food",
            hintStyle: TextStyle(color: AppTheme.textVariant.withOpacity(0.4)),
            filled: true,
            fillColor: AppTheme.surfaceLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: AppTheme.textVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {
              final newTag = tagController.text.trim().replaceAll('|', '');
              if (newTag.isNotEmpty) {
                setState(() {
                  if (!_availableTags.contains(newTag)) {
                    _availableTags.add(newTag);
                  }
                  _selectedTags.add(newTag);
                });
              }
              Navigator.pop(context);
            },
            child: const Text(
              "Add",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateFormat(
      'EEEE, MMMM d',
    ).format(DateTime.now()).toUpperCase();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- CUSTOM HEADER ---
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 16,
                right: 24,
                bottom: 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 28,
                    ),
                    color: AppTheme.textMain,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New Entry",
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(color: AppTheme.primary, fontSize: 32),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentDate,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppTheme.secondary,
                                fontSize: 12,
                                letterSpacing: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- SCROLLABLE FORM ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. BRISTOL STOOL TYPE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "BRISTOL STOOL TYPE",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _showAllTypes = !_showAllTypes),
                          child: Text(
                            _showAllTypes ? "Show Less" : "View All 7 Types",
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: AppTheme.secondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Smoothly animate between the horizontal scroll and the full grid!
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: _showAllTypes
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,

                      // COLLAPSED STATE (Top 3)
                      firstChild: Row(
                        children: [
                          Expanded(
                            child: _buildTypeCard(
                              _allStoolTypes[0],
                              double.infinity,
                            ),
                          ), // Type 1
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTypeCard(
                              _allStoolTypes[3],
                              double.infinity,
                            ),
                          ), // Type 4
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTypeCard(
                              _allStoolTypes[5],
                              double.infinity,
                            ),
                          ), // Type 6
                        ],
                      ),

                      // EXPANDED STATE (All 7 in a 2-column grid)
                      secondChild: Wrap(
                        spacing: 12,
                        runSpacing: 16,
                        children: _allStoolTypes.map((type) {
                          // Calculate width for 3 columns perfectly
                          // Screen width - Edge Padding (24 + 24) - Gap Spacing (12 + 12) / 3
                          double cardWidth =
                              (MediaQuery.of(context).size.width - 48 - 24) / 3;
                          return _buildTypeCard(type, cardWidth);
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 2. DISCOMFORT LEVEL
                    Container(
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
                                "DISCOMFORT LEVEL",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              Text(
                                _discomfortLevel.toInt().toString(),
                                style: Theme.of(context).textTheme.displayMedium
                                    ?.copyWith(
                                      color: AppTheme.secondary,
                                      fontSize: 28,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: AppTheme.secondary,
                              inactiveTrackColor: AppTheme.outline.withOpacity(
                                0.3,
                              ),
                              thumbColor: AppTheme.surfaceLowest,
                              trackHeight: 8,
                              overlayColor: AppTheme.secondary.withOpacity(0.2),
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 12,
                                elevation: 4,
                              ),
                            ),
                            child: Slider(
                              value: _discomfortLevel,
                              min: 1,
                              max: 10,
                              divisions: 9,
                              onChanged: (value) =>
                                  setState(() => _discomfortLevel = value),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.sentiment_satisfied_rounded,
                                  color: AppTheme.textVariant.withOpacity(0.5),
                                  size: 26,
                                ),
                                Icon(
                                  Icons.sentiment_neutral_rounded,
                                  color: AppTheme.textVariant.withOpacity(0.5),
                                  size: 26,
                                ),
                                Icon(
                                  Icons.sentiment_very_dissatisfied_rounded,
                                  color: AppTheme.textVariant.withOpacity(0.5),
                                  size: 26,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 3. QUICK TAGS
                    Text(
                      "QUICK TAGS",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ..._availableTags
                            .map((tag) => _buildTagPill(tag))
                            .toList(),
                        // THE NEW ADD TAG BUTTON
                        GestureDetector(
                          onTap: _showAddTagDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppTheme.outline.withOpacity(0.6),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.add,
                                  size: 18,
                                  color: AppTheme.textVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Add Tag",
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: AppTheme.textVariant,
                                        fontSize: 13,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                
                    // 5. NOTES
                    Text(
                      "NOTES",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      maxLines: 4,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: "How was your digestion today?",
                        hintStyle: TextStyle(
                          color: AppTheme.textVariant.withOpacity(0.4),
                        ),
                        filled: true,
                        fillColor: AppTheme.surfaceLow,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 24,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 6. SAVE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final newEntry = JournalEntry(
                            date: DateTime.now(),
                            type: _selectedType,
                            discomfort: _discomfortLevel,
                            tags: _selectedTags.toList(),
                            notes: _notesController.text.trim(),
                          );
                          await CsvService().saveEntry(newEntry);

                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("✨ Entry securely saved."),
                                backgroundColor: AppTheme.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.save_alt_rounded, size: 24),
                        label: const Text(
                          "Save Entry",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondary,
                          shadowColor: AppTheme.secondary.withOpacity(0.3),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildTypeCard(Map<String, String> typeData, double width) {
    String internalValue = typeData["internal"]!;
    String uiTitle = typeData["title"]!;
    String subtitle = typeData["subtitle"]!;
    String emoji = typeData["emoji"]!;

    bool isSelected = _selectedType == internalValue;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = internalValue),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.secondary : AppTheme.surfaceLow,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected ? AppTheme.sunlightShadow : [],
          border: Border.all(
            color: isSelected ? AppTheme.surfaceLowest : Colors.transparent,
            width: 4,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.15)
                    : AppTheme.outline.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(height: 16),
            Text(
              uiTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isSelected ? AppTheme.surfaceLowest : AppTheme.textMain,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? AppTheme.surfaceLowest.withOpacity(0.8)
                    : AppTheme.textVariant,
                fontSize: 10,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagPill(String label) {
    bool isSelected = _selectedTags.contains(label);

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected ? _selectedTags.remove(label) : _selectedTags.add(label);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryContainer : AppTheme.surfaceLow,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryContainer.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isSelected ? AppTheme.primary : AppTheme.textVariant,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
