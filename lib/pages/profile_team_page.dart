import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notesapp/pages/ivan_page.dart';
import 'dzidan_page.dart';
//import halaman masing masing

class ProfileTeamPage extends StatelessWidget {
  const ProfileTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> members = [
      {
        "name": "Dzidan Rafi Habibie",
        "role": "Project Manager",
        "image": "assets/images/dzidan/dzidan_img1.jpg",
      },
      {
        "name": "Nama Mahasiswa 2",
        "role": "Role 2",
        "image": "https://i.pravatar.cc/400?img=5",
      },
      {
        "name": "Nama Mahasiswa 3",
        "role": "Role 3",
        "image": "https://i.pravatar.cc/400?img=33",
      },
      {
        "name": "Nama Mahasiswa 4",
        "role": "Role 4",
        "image": "https://i.pravatar.cc/400?img=9",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Tim Pengembang",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: members.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final member = members[index];
            return _buildMemberCard(context, member, index);
          },
        ),
      ),
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    Map<String, String> member,
    int index,
  ) {
    String imagePath = member["image"]!;
    bool isNetworkImage = imagePath.startsWith('http');

    return InkWell(
      onTap: () {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DzidanPage()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IvanPage()),
            // Ganti 'NamaHalamanAnda' dengan nama class halaman profile Anda
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: isNetworkImage
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(Icons.person, color: Colors.grey),
                          ),
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(Icons.person, color: Colors.grey),
                          ),
                    ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFF29B6F6),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      member["name"]!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      member["role"]!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
