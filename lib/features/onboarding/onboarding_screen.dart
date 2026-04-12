import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // The 3 screens we planned
  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Hi Hazel! ✨",
      "subtitle": "A cozy, private space just for you.",
      "icon": "favorite", // We'll use standard icons for now
    },
    {
      "title": "Track with Ease",
      "subtitle": "Log your daily rhythm comfortably and quickly.",
      "icon": "edit_note",
    },
    {
      "title": "Completely Yours",
      "subtitle": "Everything stays on your phone. Safe, secure, and offline.",
      "icon": "lock_outline",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Hardcoding the cozy colors here temporarily until we link app_theme.dart
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
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) => _buildPageContent(
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
                  // Next / Get Started Button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        // TODO: Navigate to Home Dashboard
                        print("Navigate to Home");
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
                      _currentPage == _onboardingData.length - 1
                          ? "Get Started"
                          : "Next",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the text and icon
  Widget _buildPageContent({
    required String title,
    required String subtitle,
    required String iconString,
    required Color textBrown,
    required Color accentGreen,
  }) {
    IconData iconData = Icons.favorite;
    if (iconString == "edit_note") iconData = Icons.edit_note;
    if (iconString == "lock_outline") iconData = Icons.lock_outline;

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 100, color: accentGreen.withOpacity(0.8)),
          const SizedBox(height: 40),
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
        ],
      ),
    );
  }

  // Helper widget for the dots
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
