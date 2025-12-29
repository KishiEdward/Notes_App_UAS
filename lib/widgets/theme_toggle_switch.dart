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
    // Coba dibalik: 0.0 = Malam, 1.0 = Siang (berdasarkan feedback user)
    // Atau mungkin file lottie nya yang memang start from Night?
    // Mari coba balik value nya.
    if (widget.value) {
      _controller.value = 0.0; // Dark mode (Malam) - Asumsi frame 0
    } else {
      _controller.value = 0.5; // Light mode (Siang) - Asumsi animasi di tengah atau akhir
      // Tapi tunggu, biasanya toggle linear.
      // Coba set full reverse:
      // Dark (True) -> 1.0
      // Light (False) -> 0.0
      
      // Jika user bilang Light stop di Malam, berarti 0.0 = Malam.
      // Maka Light harusnya 1.0 (Siang)?
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ThemeToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        // Light -> Dark (Siang -> Malam)
        // Jika 1.0 = Siang, 0.0 = Malam
        _controller.reverse(); 
      } else {
        // Dark -> Light (Malam -> Siang)
        _controller.forward();
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
