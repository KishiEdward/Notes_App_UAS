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
                  Text('Gambar Bulat'),
                  SizedBox(height: 24),
                  Text('Judul'),
                  SizedBox(height: 12),
                  Text('Subjudul'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
