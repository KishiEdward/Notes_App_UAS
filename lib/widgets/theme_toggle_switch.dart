import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ThemeToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;

  const ThemeToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 60,
    this.height = 40,
  });

  @override
  State<ThemeToggleSwitch> createState() => _ThemeToggleSwitchState();
}

class _ThemeToggleSwitchState extends State<ThemeToggleSwitch> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Durasi transisi
    );

    // Set kondisi awal tanpa animasi
    if (widget.value) {
      _controller.value = 1.0; // Dark mode (Night)
    } else {
      _controller.value = 0.0; // Light mode (Day)
    }
  }

  @override
  void didUpdateWidget(ThemeToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward(); // Light -> Dark
      } else {
        _controller.reverse(); // Dark -> Light
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Lottie.asset(
          'assets/animations/Day_and_Night_Toggle.json',
          controller: _controller,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
