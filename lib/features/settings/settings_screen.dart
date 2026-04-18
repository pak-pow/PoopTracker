import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import 'edit_profile_screen.dart';
import '../../core/widgets/custom_bottom_nav.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _nickname = 'Hazel';
  String _avatar = '🌿';
  bool _remindersEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nickname = prefs.getString('nickname') ?? 'Hazel';
      _avatar = prefs.getString('avatar') ?? '🌿';
      _remindersEnabled = prefs.getBool('remindersEnabled') ?? true;
    });
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
                        "The Organic Journal",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primary,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.notifications_outlined, color: AppTheme.primary),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                // TIGHTENED BOTTOM PADDING
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 12,
                  bottom: 90,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20), // TIGHTENED
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLowest,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: AppTheme.sunlightShadow,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLow,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.primaryContainer,
                                width: 3,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _avatar,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                          const SizedBox(height: 12), // TIGHTENED
                          Text(
                            _nickname,
                            style: Theme.of(
                              context,
                            ).textTheme.displayMedium?.copyWith(fontSize: 24),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Daily Journaling since 2023",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(fontSize: 13),
                          ),
                          const SizedBox(height: 16), // TIGHTENED
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfileScreen(),
                                  ),
                                );
                                if (result == true) _loadProfileData();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.secondary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24), // TIGHTENED

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "REMINDERS",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Icon(
                          Icons.notifications_active_outlined,
                          color: AppTheme.textVariant.withOpacity(0.5),
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: AppTheme.surfaceLowest,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.alarm,
                                  color: AppTheme.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Daily Check-in",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 15),
                                  ),
                                  Text(
                                    "8:30 PM",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Switch(
                            value: _remindersEnabled,
                            activeColor: AppTheme.surfaceLowest,
                            activeTrackColor: AppTheme.primaryContainer,
                            inactiveThumbColor: AppTheme.outline,
                            inactiveTrackColor: AppTheme.surfaceLowest,
                            onChanged: (val) async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('remindersEnabled', val);
                              setState(() => _remindersEnabled = val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24), // TIGHTENED

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "DATA & PRIVACY",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Icon(
                          Icons.storage_outlined,
                          color: AppTheme.textVariant.withOpacity(0.5),
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLowest,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.file_download_outlined,
                                color: AppTheme.textMain,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                "Export CSV",
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(fontSize: 15),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppTheme.outline,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDAD6).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.delete_outline,
                                color: Color(0xFFBA1A1A),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                "Delete All Data",
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontSize: 15,
                                      color: const Color(0xFFBA1A1A),
                                    ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFBA1A1A),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24), // TIGHTENED

                    Center(
                      child: Column(
                        children: [
                          Text(
                            "\"All data stays on your device. Always.\"",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 12), // TIGHTENED
                          Text(
                            "THE ORGANIC JOURNAL",
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(
                                  fontSize: 14,
                                  color: AppTheme.primary,
                                  letterSpacing: -0.5,
                                ),
                          ),
                          Text(
                            "VERSION 1.0.0 (STABLE BUILD)",
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall?.copyWith(fontSize: 9),
                          ),
                          const SizedBox(height: 20), // TIGHTENED
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }
}
