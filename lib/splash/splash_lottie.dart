import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notesapp/pages/home_page.dart';

class MyLottie extends StatefulWidget {
  const MyLottie({super.key});

  @override
  State<MyLottie> createState() => _MyLottieState();
}

class _MyLottieState extends State<MyLottie> {
  @override
  void initState() {
    super.initState();
      navigateToHome();
}

Future<void> navigateToHome() async {
  await Future.delayed(const Duration(seconds: 2));
  if (!mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const HomePage()),
    (Route<dynamic> route) => false,
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animasi Lottie
            Lottie.asset(
              'assets/animations/Fish_Jumping.json',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}