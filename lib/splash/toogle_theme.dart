import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notesapp/main.dart';
import 'package:notesapp/services/settings_service.dart';

class ToggleThemePage extends StatefulWidget {
  const ToggleThemePage({super.key});

  @override
  State<ToggleThemePage> createState() => _ToggleThemePageState();
}

class _ToggleThemePageState extends State<ToggleThemePage> 
  with SingleTickerProviderStateMixin {

  final SettingsService _settingsService = SettingsService();
  late AnimationController _controller;
  bool _isDarkNow = false;

   @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _loadCurrentTheme();
  }

  Future<void> _loadCurrentTheme() async {
    _isDarkNow = await _settingsService.getDarkMode();
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Toggle Theme'),
      ),
    );
  }
}
