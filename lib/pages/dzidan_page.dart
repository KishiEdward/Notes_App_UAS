import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DzidanPage extends StatelessWidget {
  const DzidanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF2E7D32);
    final Color accentGreen = const Color(0xFF81C784);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Dzidan Rafi Habibie",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
