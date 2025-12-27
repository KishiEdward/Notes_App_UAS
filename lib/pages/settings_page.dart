import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notesapp/main.dart';
import 'package:notesapp/services/settings_service.dart';
import 'package:notesapp/services/firestore_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:notesapp/utils/notification_helper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsService _settingsService = SettingsService();
  final FirestoreService _firestoreService = FirestoreService();

  bool _darkMode = false;
  String _fontSize = 'medium';
  String _defaultCategory = 'Pribadi';

  final List<String> _categories = ['Pribadi', 'Pekerjaan', 'Ide', 'Penting'];
  final List<String> _fontSizes = ['small', 'medium', 'large'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final darkMode = await _settingsService.getDarkMode();
    final fontSize = await _settingsService.getFontSize();
    final defaultCategory = await _settingsService.getDefaultCategory();

    setState(() {
      _darkMode = darkMode;
      _fontSize = fontSize;
      _defaultCategory = defaultCategory;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    await _settingsService.setDarkMode(value);
    setState(() {
      _darkMode = value;
    });
    
    MyApp.of(context).changeTheme(value);
  }

  Future<void> _changeFontSize(String value) async {
    await _settingsService.setFontSize(value);
    setState(() {
      _fontSize = value;
    });
    
    double scaleValue = _settingsService.getFontSizeValue(value);
    
    MyApp.of(context).changeFontSize(scaleValue);
  }

  Future<void> _changeDefaultCategory(String value) async {
    await _settingsService.setDefaultCategory(value);
    setState(() {
      _defaultCategory = value;
    });
  }

  Future<void> _exportNotes() async {
    try {
      final notes = await _firestoreService.getAllNotes();
      final jsonData = notes.map((note) => note.toMap()).toList();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/notes_export.json');
      await file.writeAsString(jsonString);

      if (mounted) {
        showTopNotification(
          context,
          'Notes berhasil di-export ke ${file.path}',
          color: Colors.green.shade600,
        );
      }
    } catch (e) {
      if (mounted) {
        showTopNotification(
          context,
          'Gagal export notes',
          color: Colors.red.shade600,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor, 
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _darkMode ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: _darkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection(
            'Appearance',
            [
              _buildSwitchTile(
                'Dark Mode',
                Icons.dark_mode_outlined,
                _darkMode,
                _toggleDarkMode,
              ),
              _buildDropdownTile(
                'Font Size',
                Icons.text_fields,
                _fontSize,
                _fontSizes,
                (value) => _changeFontSize(value!),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            'Preferences',
            [
              _buildDropdownTile(
                'Default Category',
                Icons.category_outlined,
                _defaultCategory,
                _categories,
                (value) => _changeDefaultCategory(value!),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            'Data',
            [
              _buildActionTile(
                'Export Notes',
                Icons.download_outlined,
                _exportNotes,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            'About',
            [
              _buildInfoTile('Version', '1.0.0'),
              _buildInfoTile('Developer', 'Notes App Team'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _darkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _darkMode ? Colors.grey.shade800 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, IconData icon, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade600),
      title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue.shade600,
      ),
    );
  }

  Widget _buildDropdownTile(String title, IconData icon, String value, List<String> items, Function(String?) onChanged) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade600),
      title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
      trailing: DropdownButton<String>(
        value: value,
        dropdownColor: _darkMode ? Colors.grey.shade800 : Colors.white,
        underline: const SizedBox(),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: GoogleFonts.poppins(fontSize: 14)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade600),
      title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      leading: Icon(Icons.info_outline, color: Colors.blue.shade600),
      title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
      trailing: Text(value, style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 14)),
    );
  }
}