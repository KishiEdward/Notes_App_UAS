import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notesapp/services/fcm_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final FCMService _fcmService = FCMService();
  bool _notificationsEnabled = true;
  bool _dailyReminderEnabled = false;
  bool _streakReminderEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyReminderEnabled = prefs.getBool('dailyReminderEnabled') ?? false;
      _streakReminderEnabled = prefs.getBool('streakReminderEnabled') ?? false;
    });
  }

  Future<void> _saveDailyReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyReminderEnabled', value);
  }

  Future<void> _saveStreakReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('streakReminderEnabled', value);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text('Enable Notifications', style: GoogleFonts.poppins()),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: Text('Daily Reminder (8 AM)', style: GoogleFonts.poppins()),
            subtitle: Text('Ingetin bikin catatan tiap pagi', style: GoogleFonts.poppins(fontSize: 12)),
            value: _dailyReminderEnabled,
            onChanged: (value) async {
              setState(() => _dailyReminderEnabled = value);
              await _saveDailyReminder(value);
              if (value) {
                await _fcmService.scheduleDailyReminder();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Daily reminder enabled! 🌅', style: GoogleFonts.poppins())),
                  );
                }
              } else {
                await _fcmService.cancelDailyReminder();
              }
            },
          ),
          SwitchListTile(
            title: Text('Streak Reminder (8 PM)', style: GoogleFonts.poppins()),
            subtitle: Text('Ingetin jaga streak kalau belum bikin catatan', style: GoogleFonts.poppins(fontSize: 12)),
            value: _streakReminderEnabled,
            onChanged: (value) async {
              setState(() => _streakReminderEnabled = value);
              await _saveStreakReminder(value);
              if (value) {
                await _fcmService.scheduleStreakReminder();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Streak reminder enabled! 🔥', style: GoogleFonts.poppins())),
                  );
                }
              } else {
                await _fcmService.cancelStreakReminder();
              }
            },
          ),
          const SizedBox(height: 20),
          Text('Debug Tools', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              final token = await _fcmService.getToken();
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('FCM Token', style: GoogleFonts.poppins()),
                    content: SelectableText(token ?? 'No token available'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close', style: GoogleFonts.poppins()),
                      ),
                    ],
                  ),
                );
              }
            },
            icon: const Icon(Icons.key),
            label: Text('Show FCM Token', style: GoogleFonts.poppins()),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              final enabled = await _fcmService.areNotificationsEnabled();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      enabled ? 'Notifications ENABLED ✅' : 'Notifications DISABLED ❌',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.check_circle),
            label: Text('Check Permission', style: GoogleFonts.poppins()),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              await _fcmService.requestPermission();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Permission requested!', style: GoogleFonts.poppins()),
                  ),
                );
              }
            },
            icon: const Icon(Icons.notifications_active),
            label: Text('Request Permission', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }
}
