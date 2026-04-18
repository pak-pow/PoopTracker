import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
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

  // Avatar Selection State
  final List<String> _avatars = ['🌸', '🌿', '🍄', '✨', '🐻', '🐸', '🦊', '☁️'];
  String _selectedAvatar = '🌿';

  // Reminder State
  bool _remindersEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(
    hour: 20,
    minute: 30,
  ); // Defaults to 8:30 PM

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    if (_nameController.text.trim().isEmpty) {
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please let us know your name!"),
          backgroundColor: AppTheme.secondary,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    await prefs.setString('nickname', _nameController.text.trim());
    await prefs.setString('avatar', _selectedAvatar);
    await prefs.setBool('remindersEnabled', _remindersEnabled);
    await prefs.setInt('reminderHour', _reminderTime.hour);
    await prefs.setInt('reminderMinute', _reminderTime.minute);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP PROGRESS INDICATOR ---
            if (_currentPage < 3)
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 32, right: 32),
                child: Row(
                  children: List.generate(3, (index) {
                    bool isActive = index == _currentPage;
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        margin: EdgeInsets.only(right: index == 2 ? 0 : 8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppTheme.primary
                              : AppTheme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),

            // --- PAGE CONTENT ---
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (val) => setState(() => _currentPage = val),
                children: [
                  _buildWelcomePage(),
                  _buildProfilePage(),
                  _buildReminderPage(),
                  _buildCompletePage(),
                ],
              ),
            ),

            // --- FOOTER ACTION BUTTON ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == 3) {
                          _completeOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == 0
                                ? "Get Started"
                                : (_currentPage == 2
                                      ? "Save My Ritual"
                                      : (_currentPage == 3
                                            ? "Start Tracking"
                                            : "Continue")),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentPage == 0
                        ? "100% PRIVACY FOCUSED"
                        : "SECURELY ENCRYPTED ON DEVICE",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: AppTheme.textVariant.withOpacity(0.5),
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

  // --- INDIVIDUAL PAGES ---

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppTheme.surfaceLowest,
              borderRadius: BorderRadius.circular(40),
              boxShadow: AppTheme.sunlightShadow,
            ),
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/logo_capybara.png'),
          ),
          const SizedBox(height: 48),
          Text(
            "The Organic Journal",
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontSize: 32),
          ),
          const SizedBox(height: 12),
          Text(
            "Your private gut health sanctuary",
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppTheme.textVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Let's make it personal.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 28,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Choose a name and a friendly avatar for your private journal.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 40),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "WHAT SHOULD WE CALL YOU?",
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
          TextField(
            controller: _nameController,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: "Your nickname...",
              filled: true,
              fillColor: AppTheme.surfaceLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "CHOOSE YOUR AVATAR",
              style: TextStyle(
                fontFamily: 'JakartaSans',
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: AppTheme.textVariant,
              ),
            ),
          ),
          const SizedBox(height: 16),
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
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryContainer
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ]
                        : AppTheme.sunlightShadow,
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontSize: 36, height: 1.1),
              children: [
                const TextSpan(text: "Cultivate a\n"),
                TextSpan(
                  text: "Daily Ritual",
                  style: TextStyle(color: AppTheme.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Consistency is the key to understanding your inner health journey.",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.4),
          ),

          const Spacer(flex: 2),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLow,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Set a daily reminder?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Gently nudge your routine",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _remindersEnabled,
                  activeColor: AppTheme.surfaceLowest,
                  activeTrackColor: AppTheme.primary,
                  inactiveThumbColor: AppTheme.outline,
                  inactiveTrackColor: AppTheme.surfaceLowest,
                  onChanged: (val) => setState(() => _remindersEnabled = val),
                ),
              ],
            ),
          ),

          const Spacer(flex: 2),

          AnimatedOpacity(
            opacity: _remindersEnabled ? 1.0 : 0.3,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: !_remindersEnabled,
              child: SizedBox(
                height: 160,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 28, color: AppTheme.textMain),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime(
                      2020,
                      1,
                      1,
                      _reminderTime.hour,
                      _reminderTime.minute,
                    ),
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        _reminderTime = TimeOfDay.fromDateTime(newDateTime);
                      });
                    },
                  ),
                ),
              ),
            ),
          ),

          const Spacer(flex: 2),

          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.secondary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_active_rounded,
                size: 32,
                color: AppTheme.secondary,
              ),
            ),
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _buildCompletePage() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLowest,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.sunlightShadow,
                  border: Border.all(
                    color: AppTheme.primaryContainer,
                    width: 4,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _selectedAvatar,
                  style: const TextStyle(fontSize: 60),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text("You're all set,", style: Theme.of(context).textTheme.bodyLarge),
          Text(
            _nameController.text,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppTheme.primary,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Your digital sanctuary is ready. Let's start capturing your journey today.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
