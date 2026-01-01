import 'package:flutter/material.dart';
import 'package:notesapp/pages/login_page.dart';


class Splash4 extends StatefulWidget {
  const Splash4({super.key});

  @override
  State<Splash4> createState() => _Splash4State();
}

class _Splash4State extends State<Splash4>
    with SingleTickerProviderStateMixin {
    late AnimationController _controller;
    late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 420,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //gambar bulat
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 230,
                      height: 230,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/loopy_lembur.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                    ),

                  //TEKS judul dan sub-judul
                  const SizedBox(height: 24),
                  Text(                
                    'siap mulai catat ide?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'simpan ide, tugas, dan hal penting\nlangsung dari genggamanmu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 24),

                  //indikator splash
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _indicator(false),
                      _indicator(false),
                      _indicator(false),
                      _indicator(true),
                    ],
                  ),


                   const SizedBox(height: 32),
                  // tombol
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Mulai',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  // indikator versi rounded pill
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFF06292)
            : Colors.pink.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
