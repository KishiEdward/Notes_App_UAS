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
      _navigateToHome();
}

_navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (Route<dynamic> route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}