import 'package:flutter/material.dart';

class ToggleThemePage extends StatefulWidget {
  const ToggleThemePage({super.key});

  @override
  State<ToggleThemePage> createState() => _ToggleThemePageState();
}

class _ToggleThemePageState extends State<ToggleThemePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Toggle Theme'),
      ),
    );
  }
}
