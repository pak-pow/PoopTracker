import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  // A cute list of emojis for her to choose from!
  final List<String> _avatars = ['🌸', '🌿', '🍄', '✨', '☕', '📖', '🦋', '🌙'];
  String _selectedAvatar = '🌸';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Fetch the data we saved during Onboarding
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('nickname') ?? 'Hazel';
      _selectedAvatar = prefs.getString('avatar') ?? '🌸';
      _isLoading = false;
    });
  }

  // Save the updated data
  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Nickname can't be empty!")));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nickname', _nameController.text.trim());
    await prefs.setString('avatar', _selectedAvatar);

    if (!mounted) return;

    // Show a success message and pop back to settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated beautifully! ✨"),
        backgroundColor: Color(0xFFA3B18A),
      ),
    );
    Navigator.pop(context, true); // Pass 'true' back to tell the app to refresh
  }

  @override
  Widget build(BuildContext context) {
    const Color bgCream = Color(0xFFFDFCF5);
    const Color textBrown = Color(0xFF3A3A3A);
    const Color accentGreen = Color(0xFFA3B18A);

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: bgCream,
        body: Center(child: CircularProgressIndicator(color: accentGreen)),
      );
    }

    return Scaffold(
      backgroundColor: bgCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textBrown),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: textBrown, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Choose an Avatar",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textBrown,
                ),
              ),
              const SizedBox(height: 16),

              // The Avatar Grid
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: _avatars.map((emoji) {
                  final isSelected = emoji == _selectedAvatar;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAvatar = emoji),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? accentGreen.withOpacity(0.2)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected ? accentGreen : Colors.transparent,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          if (!isSelected)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Text(emoji, style: const TextStyle(fontSize: 32)),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),
              const Text(
                "Your Nickname",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textBrown,
                ),
              ),
              const SizedBox(height: 16),

              // The Text Field (Matching your new design)
              TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textBrown,
                ),
                cursorColor: accentGreen,
                decoration: InputDecoration(
                  hintText: "e.g. Hazel, Bub, etc...",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 24,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: accentGreen.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: accentGreen, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Save Button
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
