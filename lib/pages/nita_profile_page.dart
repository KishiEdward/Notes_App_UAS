import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NitaProfilePage extends StatelessWidget {
  const NitaProfilePage({super.key});

  //pallete warna yg digunakan
  static const Color roseQuartz = Color(0xFFF9CBD6);
  static const Color blush = Color(0xFFF2AFBC);
  static const Color redWine = Color(0xFF9E182B);
  static const Color oatMilk = Color(0xFFF2E0D2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: oatMilk,
      body: Center(
        child: Text(
          'Profile Nita',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: redWine,
          ),
        ),
      ),
    );
  }
}