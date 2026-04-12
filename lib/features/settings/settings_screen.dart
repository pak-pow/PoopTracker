import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../history/history_screen.dart';
import '../../data/services/google_drive_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Toggle States
  bool _driveSyncEnabled = false;
  bool _remindersEnabled = true;

  // --- THEME COLORS ---
  final Color bgCream = const Color(0xFFFDFCF5);
  final Color textBrown = const Color(0xFF3A3A3A);
  final Color accentGreen = const Color(0xFFA3B18A);
  final Color accentPeach = const Color(0xFFE29578);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account & Sync",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textBrown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Manage your data and preferences",
                    style: TextStyle(
                      color: textBrown.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // --- CONTENT ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildSectionHeader("DATA HANDLING"),
                  const SizedBox(height: 12),
                  _buildDataCard(),

                  const SizedBox(height: 32),

                  _buildSectionHeader("PREFERENCES"),
                  const SizedBox(height: 12),
                  _buildPreferencesCard(),

                  const SizedBox(height: 40),

                  // LOG OUT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Log out logic
                      },
                      icon: Icon(Icons.logout, color: accentPeach),
                      label: Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: accentPeach,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: accentPeach.withOpacity(0.3),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),

      // --- BOTTOM NAVIGATION ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: 2, // ACCOUNT is selected
            onTap: (index) {
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
              }
            },
            selectedItemColor: accentPeach,
            unselectedItemColor: accentGreen.withOpacity(0.5),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(Icons.home_filled),
                ),
                label: 'Today',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(Icons.calendar_today_rounded),
                ),
                label: 'Journal',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(Icons.settings_outlined),
                ),
                label: 'Account',
              ),
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

  Widget _buildDataCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Offline Status
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentGreen.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shield_outlined, color: accentGreen, size: 22),
            ),
            title: Text(
              "Offline Mode Active",
              style: TextStyle(fontWeight: FontWeight.bold, color: textBrown),
            ),
            subtitle: Text(
              "Your data is safe and private.",
              style: TextStyle(color: textBrown.withOpacity(0.6), fontSize: 12),
            ),
          ),
          Divider(height: 1, color: bgCream, thickness: 2),
          // Google Drive Sync
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentPeach.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.cloud_queue, color: accentPeach, size: 22),
            ),
            title: Text(
              "Google Drive Backup",
              style: TextStyle(fontWeight: FontWeight.bold, color: textBrown),
            ),
            subtitle: Text(
              "App will automatically sync CSV when internet is detected.",
              style: TextStyle(color: textBrown.withOpacity(0.6), fontSize: 12),
            ),
            trailing: Switch(
              value: _driveSyncEnabled,
              activeColor: accentPeach,
              activeTrackColor: accentPeach.withOpacity(0.3),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: bgCream,
              onChanged: (val) async {
                setState(() => _driveSyncEnabled = val);

                if (val == true) {
                  // Show a loading snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text("Syncing to Google Drive..."),
                        ],
                      ),
                      backgroundColor: textBrown,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  // Trigger the sync!
                  bool success = await GoogleDriveService().syncBackupToDrive();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? "✨ Backup successful!"
                              : "❌ Backup failed. Check connection.",
                        ),
                        backgroundColor: success ? accentGreen : accentPeach,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                    // If it failed, toggle the switch back off
                    if (!success) {
                      setState(() => _driveSyncEnabled = false);
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Daily Reminders
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentPeach.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none,
                color: accentPeach,
                size: 22,
              ),
            ),
            title: Text(
              "Daily Reminders",
              style: TextStyle(fontWeight: FontWeight.bold, color: textBrown),
            ),
            subtitle: Text(
              "8:00 PM",
              style: TextStyle(color: textBrown.withOpacity(0.6), fontSize: 12),
            ),
            trailing: Switch(
              value: _remindersEnabled,
              activeColor: accentGreen,
              activeTrackColor: accentGreen.withOpacity(0.3),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: bgCream,
              onChanged: (val) {
                setState(() => _remindersEnabled = val);
              },
            ),
          ),
          Divider(height: 1, color: bgCream, thickness: 2),
          // Edit Profile
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: bgCream, shape: BoxShape.circle),
              child: Text(
                "H",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textBrown,
                  fontSize: 16,
                ),
              ),
            ),
            title: Text(
              "Edit Profile",
              style: TextStyle(fontWeight: FontWeight.bold, color: textBrown),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: textBrown.withOpacity(0.3),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
