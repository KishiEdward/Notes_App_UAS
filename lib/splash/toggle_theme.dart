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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Lottie.asset(
          'assets/animations/Day_and_Night_Toggle.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration;

            if (_isDarkNow) {
              // Current is Dark, so switch to Light
              // Animation: Night -> Day (Reverse)
              _controller.reverse(from: 1).then((_) {
                 _updateTheme(false);
              });
            } else {
              // Current is Light, so switch to Dark
              // Animation: Day -> Night (Forward)
              _controller.forward(from: 0).then((_) {
                 _updateTheme(true);
              });
            }
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
        ),
      ),
    );
  }
}
