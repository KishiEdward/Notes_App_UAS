
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:notesapp/pages/login_page.dart';
import 'package:notesapp/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Future<void> _onIntroEnd(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_time', false);

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  PageDecoration _getPageDecoration() {
    return PageDecoration(
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 24.0, 
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
      bodyTextStyle: GoogleFonts.poppins(
        fontSize: 16.0,
        height: 1.5,
        color: Theme.of(context).brightness == Brightness.dark 
            ? Colors.grey.shade300 
            : Colors.grey.shade700,
      ),
      bodyPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      pageColor: Theme.of(context).scaffoldBackgroundColor,
      imagePadding: const EdgeInsets.only(top: 80), 
      imageFlex: 2, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: false,
      pages: [
        PageViewModel(
          title: "Selamat Datang",
          body: "Catat ide, tugas, dan hal penting lainnya dengan NekoMind.",
          image: Lottie.asset('assets/animations/White Cat Peeping.json', height: 200),
          decoration: _getPageDecoration(),
        ),
        PageViewModel(
          title: "Fitur Lengkap",
          body: "Mulai dari kategori, pin, hingga pencarian yang cepat.",
          image: Lottie.asset('assets/animations/Black Cat Green Eyes Peeping.json', height: 200),
          decoration: _getPageDecoration(),
        ),
        PageViewModel(
          title: "Tetap Produktif",
          body: "Jaga streak dan aktifkan reminder agar tidak lupa.",
          image: Lottie.asset('assets/animations/Fish_Jumping.json', height: 200),
          decoration: _getPageDecoration(),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      back: const Icon(Icons.arrow_back),
      skip: Text(
        'Lewati', 
        style: TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 16,
          color: Theme.of(context).primaryColor,
        ),
      ),
      next: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.arrow_forward_rounded, color: Theme.of(context).primaryColor),
      ),
      done: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Text(
          'Mulai',
          style: TextStyle(
            fontWeight: FontWeight.w600, 
            color: Colors.white,
          ),
        ),
      ),
      curve: Curves.easeInOut,
      controlsMargin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      controlsPadding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(24.0, 10.0),
        activeColor: Theme.of(context).primaryColor,
        color: Theme.of(context).disabledColor,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
