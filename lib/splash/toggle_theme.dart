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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan target mode: Kebalikan dari sekarang
    bool targetModeIsDark = !_isDarkNow; 
    
    return Scaffold(
      // Background menyesuaikan target mode
      backgroundColor: targetModeIsDark ? Colors.black : Colors.white,
      body: Center(
        child: Lottie.asset(
          targetModeIsDark 
              ? 'assets/animations/Black Cat Green Eyes Peeping.json' 
              : 'assets/animations/White Cat Peeping.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration;
            _controller.forward().then((_) {
               _updateTheme(targetModeIsDark);
            });
          },
        ),
      ),
    );
  }

  Future<void> _updateTheme(bool isDark) async {
    await _settingsService.setDarkMode(isDark);
    if (mounted) {
      MyApp.of(context).changeTheme(isDark);
      Navigator.pop(context);
    }
  }
}
