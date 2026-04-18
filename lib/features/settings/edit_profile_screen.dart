import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _avatars = ['🌸', '🌿', '🍄', '✨', '🐻', '🐸', '🦊', '☁️'];
  String _selectedAvatar = '🌿';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('nickname') ?? 'Hazel';
      _selectedAvatar = prefs.getString('avatar') ?? '🌿';
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nickname', _nameController.text.trim());
    await prefs.setString('avatar', _selectedAvatar);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      );

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 24,
                bottom: 8,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, size: 28),
                    color: AppTheme.textMain,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 32, right: 32, bottom: 20),
                child: Column(
                  // We change this to CrossAxisAlignment.center to align everything!
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Edit Profile",
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(fontSize: 32),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Choose how you're seen in your journal",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32), // Added some breathing room
                    // --- CENTERED AVATAR PREVIEW ---
                    Center(
                      // Explicitly centered
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLowest,
                              shape: BoxShape.circle,
                              // Added the Terracotta border from the mockup!
                              border: Border.all(
                                color: AppTheme.secondary,
                                width: 3,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0A000000),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _selectedAvatar,
                              style: const TextStyle(fontSize: 50),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .primary, // Using Sage Green for the Edit icon
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.background,
                                width: 4,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: AppTheme.surfaceLowest,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "TAP TO CHANGE EMOJI",
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 32),

                    // --- NICKNAME INPUT ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "NICKNAME",
                        style: TextStyle(
                          fontFamily: 'JakartaSans',
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: AppTheme.textVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 18),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.surfaceLow,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- QUICK PICKERS ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "QUICK PICKERS",
                        style: TextStyle(
                          fontFamily: 'JakartaSans',
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: AppTheme.textVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: _avatars.map((emoji) {
                        final isSelected = emoji == _selectedAvatar;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedAvatar = emoji),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLowest,
                              borderRadius: BorderRadius.circular(16),
                              // Smooth selection highlight
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryContainer
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.primary.withOpacity(
                                          0.1,
                                        ),
                                        blurRadius: 10,
                                      ),
                                    ]
                                  : AppTheme.sunlightShadow,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 26),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // --- BUTTONS ---
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Save Changes",
                              style: TextStyle( 
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Discard changes",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
