import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTeamPage extends StatelessWidget {
  const ProfileTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profile Team",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Text(
          "Halaman Profile Team",
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
      ),
    );
  }
}
