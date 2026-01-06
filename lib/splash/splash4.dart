import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notesapp/pages/login_page.dart';

class Splash4 extends StatefulWidget {
  const Splash4({super.key});

  @override
  State<Splash4> createState() => _Splash4State();
}

class _Splash4State extends State<Splash4>
    with SingleTickerProviderStateMixin {
  // controller buat animasi pop up gambar
  late AnimationController _controller;

  // animasi scale (zoom in)
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // durasi animasi disamain, ga terlalu lama
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // curve biar efek pop up halus
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    // mulai animasi pas halaman kebuka
    _controller.forward();
  }

  @override
  void dispose() {
    // wajib dispose biar ga bocor memory
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // gambar utama (pop up animation)
            // ukuran disamain sama splash 1-3 (200x200)
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/loopy_lembur.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // jarak gambar ke judul
            const SizedBox(height: 30),

            // judul splash
            // font size & warna ngikutin splash 1-3
            Text(
              "Siap mulai?",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),

            // jarak judul ke deskripsi
            const SizedBox(height: 10),

            // deskripsi singkat
            Text(
              "Login/Register dan mulai jurnal Anda",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
            ),

            // jarak ke indikator
            const SizedBox(height: 30),

            // indikator splash (aktif di splash ke-4)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _indicator(false),
                _indicator(false),
                _indicator(false),
                _indicator(true),
              ],
            ),

            // jarak indikator ke tombol
            const SizedBox(height: 40),

            // tombol utama ke halaman login
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                height: 56, // tinggi tombol disamain splash lain
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // pindah ke login dan hapus splash dari stack
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    "Mulai sekarang",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // widget indikator splash
  // active = panjang, non active = bulat kecil
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).primaryColor
            : Theme.of(context).disabledColor,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
