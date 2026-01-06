import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NitaProfilePage extends StatelessWidget {
  const NitaProfilePage({super.key});

  // pallete warna yg digunakan
  static const Color roseQuartz = Color(0xFFF9CBD6);
  static const Color blush = Color(0xFFF2AFBC);
  static const Color redWine = Color(0xFF9E182B);
  static const Color oatMilk = Color(0xFFF2E0D2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/cherry_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.65),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text(
                  'profile nita',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: redWine,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
