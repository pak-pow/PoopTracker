import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  int _currentPage = 0;

  // The new Avatar data
  final List<String> _avatars = ['🌸', '🌿', '🍄', '✨', '☕', '📖', '🦋', '🌙'];
  String _selectedAvatar = '🌸'; // Default

  // Now we have 4 screens!
  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Hello, Welcome!✨",
      "subtitle": "A cozy, private space just for you.",
      "icon": "favorite",
    },
    {
      "title": "Track with Ease",
      "subtitle": "Log your daily poop comfortably and quickly.",
      "icon": "edit_note",
    },
    {
      "title": "Completely Yours",
      "subtitle": "Everything stays on your phone. What should we call you?",
      "icon": "lock_outline",
    },
    {
      "title": "Pick an Avatar",
      "subtitle": "Choose a vibe for your profile, or skip for now.",
      "icon": "face",
    },
  ];

  Future<void> _completeOnboarding() async {
    // Only check the name on the 3rd page, or if they hit complete on the 4th
    if (_nameController.text.trim().isEmpty) {
      // Force them back to page 3 if they try to skip without a name
      _pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a nickname first!")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    await prefs.setString('nickname', _nameController.text.trim());
    await prefs.setString('avatar', _selectedAvatar); // Save the chosen avatar!

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color bgCream = Color(0xFFFDFCF5);
    const Color textBrown = Color(0xFF3A3A3A);
    const Color accentGreen = Color(0xFFA3B18A);

    return Scaffold(
      backgroundColor: bgCream,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) => _buildPageContent(
                  index: index,
                  title: _onboardingData[index]["title"]!,
                  subtitle: _onboardingData[index]["subtitle"]!,
                  iconString: _onboardingData[index]["icon"]!,
                  textBrown: textBrown,
                  accentGreen: accentGreen,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot Indicators
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                      (index) =>
                          _buildDot(index: index, activeColor: accentGreen),
                    ),
                  ),

                  // The Skip/Next/Finish Buttons
                  Row(
                    children: [
                      // Show "Skip" only on the Avatar page (Page 4)
                      if (_currentPage == 3)
                        TextButton(
                          onPressed:
                              _completeOnboarding, // Skips and saves default
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              color: textBrown.withOpacity(0.5),
                              fontSize: 16,
                            ),
                          ),
                        ),

                      const SizedBox(width: 8),

                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage == 3) {
                            _completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          _currentPage == 3 ? "Get Started" : "Next",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent({
    required int index,
    required String title,
    required String subtitle,
    required String iconString,
    required Color textBrown,
    required Color accentGreen,
  }) {
    IconData iconData = Icons.favorite;
    if (iconString == "edit_note") iconData = Icons.edit_note;
    if (iconString == "lock_outline") iconData = Icons.lock_outline;
    if (iconString == "face") iconData = Icons.face;

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Don't show the big icon on the avatar selection screen
          if (index != 3)
            Icon(iconData, size: 100, color: accentGreen.withOpacity(0.8)),
          if (index != 3) const SizedBox(height: 40),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textBrown,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: textBrown.withOpacity(0.7),
              height: 1.5,
            ),
          ),

          // Page 3: The Nickname Field
          if (index == 2) ...[
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textBrown,
              ),
              cursorColor: accentGreen,
              decoration: InputDecoration(
                hintText: "e.g. Vince, Bub, etc...",
                hintStyle: TextStyle(
                  color: textBrown.withOpacity(0.4),
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
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
                  borderSide: BorderSide(color: accentGreen, width: 2),
                ),
              ),
            ),
          ],

          // Page 4: The Avatar Grid
          if (index == 3) ...[
            const SizedBox(height: 32),
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
          ],
        ],
      ),
    );
  }

  AnimatedContainer _buildDot({
    required int index,
    required Color activeColor,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? activeColor
            : activeColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
