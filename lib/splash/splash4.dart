import 'package:flutter/material.dart';

class Splash4 extends StatelessWidget {
  const Splash4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 420,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //gambar bulat
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                    ),
                  ),

                  //judul dan sub-judul
                  SizedBox(height: 24),
                  Text(                
                    'siap mulai catat ide?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'simpan ide, tugas, dan hal penting\nlangsung dari genggamanmu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
