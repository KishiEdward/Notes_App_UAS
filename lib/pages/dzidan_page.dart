import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class DzidanPage extends StatelessWidget {
  const DzidanPage({super.key});

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://github.com/KishiEdward');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF2E7D32);
    final Color accentGreen = const Color(0xFF66BB6A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Dzidan Rafi Habibie",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          primaryGreen,
                          accentGreen,
                          Colors.yellow[700]!,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        backgroundImage: AssetImage(
                          "assets/images/dzidan/dzidan_img1.jpg",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn("1123150045", "NIM"),
                        _buildStatColumn("TI SE 23 M", "Kelas"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dzidan Rafi Habibie",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                      children: [
                        const TextSpan(
                          text: "Mobile Developer & Laravel Enthusiast 👨‍💻\n",
                        ),
                        const TextSpan(
                          text: "Membangun masa depan dengan kode.\n",
                        ),
                        TextSpan(
                          text: "#Flutter #Laravel12 #Dart",
                          style: TextStyle(color: primaryGreen),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: _launchURL,
                    child: Text(
                      "https://github.com/KishiEdward",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF1B5E20),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                children: [
                  _buildHighlight("Flutter", Icons.flutter_dash, primaryGreen),
                  _buildHighlight("Laravel", Icons.php, Colors.indigo),
                  _buildHighlight("Git", Icons.code, Colors.orange),
                  _buildHighlight("Dart", Icons.data_object, Colors.blue),
                  _buildHighlight("MySQL", Icons.storage, Colors.blueGrey),
                ],
              ),
            ),

            Column(
              children: [
                const Divider(height: 1, color: Colors.grey),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: primaryGreen, width: 2),
                          ),
                        ),
                        child: Icon(Icons.grid_on, color: primaryGreen),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (context, index) {
                final String imagePath =
                    "assets/images/dzidan/dzidan_img${index + 2}.jpg";

                return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.2),
                      builder: (context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Dialog(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            insetPadding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    color: Colors.grey[200],
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey[400],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildHighlight(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[50],
              ),
              child: Icon(icon, size: 30, color: color),
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: GoogleFonts.poppins(fontSize: 11)),
        ],
      ),
    );
  }
}
