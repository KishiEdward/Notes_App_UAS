
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:notesapp/pages/login_page.dart';
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
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  PageDecoration _getPageDecoration() {
    return PageDecoration(
      titleTextStyle: GoogleFonts.poppins(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: GoogleFonts.poppins(fontSize: 19.0),
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Theme.of(context).scaffoldBackgroundColor,
      imagePadding: EdgeInsets.zero,
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
      skip: Text('Lewati', style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor)),
      next: Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor),
      done: Text('Mulai', style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Colors.grey.shade400,
        activeColor: Theme.of(context).primaryColor,
        activeSize: const Size(22.0, 10.0),
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
