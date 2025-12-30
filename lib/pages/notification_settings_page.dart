import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notesapp/services/fcm_service.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final FCMService _fcmService = FCMService();
  bool _notificationsEnabled = true;

  @override
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
