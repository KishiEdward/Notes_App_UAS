import 'package:flutter/material.dart';

class NitaProfilePage extends StatelessWidget {
  const NitaProfilePage({super.key});

  //pallete warna yg digunakan
  static const Color roseQuartz = Color(0xFFF9CBD6);
  static const Color blush = Color(0xFFF2AFBC);
  static const Color redWine = Color(0xFF9E182B);
  static const Color oatMilk = Color(0xFFF2E0D2);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('profile nita'),
      ),
    );
  }
}
