import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ThemeToggleSwitch extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: SizedBox(
        width: width,
        height: height,
        child: Lottie.asset(
          value
              ? 'assets/animations/Black Cat Green Eyes Peeping.json'
              : 'assets/animations/White Cat Peeping.json',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
