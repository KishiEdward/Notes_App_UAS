import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NitaProfilePage extends StatelessWidget {
  const NitaProfilePage({super.key});

  // pallete warna yg digunakan
  static const Color roseQuartz = Color(0xFFF9CBD6);
  static const Color blush = Color(0xFFF2AFBC);
  static const Color redWine = Color(0xFF9E182B);
  static const Color oatMilk = Color(0xFFF2E0D2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/cherry_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.65),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _circleButton(
                        icon: Icons.arrow_back_ios_new,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'profile nita',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: redWine,
                        ),
                      ),
                      _circleButton(
                        icon: Icons.edit_outlined,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                // card utama
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: blush.withOpacity(0.3),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),

                          // avatar profile
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: blush,
                                width: 1.5,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 48,
                              backgroundImage: AssetImage(
                                'assets/images/loopy_lembur.jpg',
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // nama
                          Text(
                            'Rismanita Lestari',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: redWine,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // role
                          Text(
                            'Mobile Developer • UI/UX Enthusiast',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // statistik profile
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              _StatItem(title: 'Following', value: '120'),
                              _StatItem(title: 'Followers', value: '340'),
                              _StatItem(title: 'Projects', value: '8'),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: oatMilk.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'halaman profil ini dibuat oleh Rismanita Lestari (1123150058) kelas TI 23 M SE sebagai bagian dari project uas mata kuliah mobile development menggunakan flutter. aplikasi notes ini dibuat fokus pada tampilan sederhana, konsisten, dan mudah digunakan.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                height: 1.5,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//widget
Widget _circleButton({
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: NitaProfilePage.blush.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 18,
        color: NitaProfilePage.redWine,
      ),
    ),
  );
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: NitaProfilePage.redWine,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
