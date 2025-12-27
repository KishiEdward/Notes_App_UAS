import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        "question": "Bagaimana cara memulihkan catatan?",
        "answer":
            "Jika Anda tidak sengaja menghapus catatan, pergi ke menu 'Sampah' di halaman utama (ikon tempat sampah). Cari catatan Anda, lalu tekan tombol 'Pulihkan' untuk mengembalikannya ke daftar utama.",
      },
      {
        "question": "Apakah catatan saya aman?",
        "answer":
            "Ya! Semua catatan Anda disimpan secara aman di Cloud (Google Firebase). Selama Anda ingat email dan password login, Anda bisa mengakses catatan dari perangkat manapun.",
      },
      {
        "question": "Bagaimana cara mengganti Password?",
        "answer":
            "Pergi ke menu Profil > Edit Profil. Di bagian paling bawah, tekan tombol 'Ganti Password via Email'. Link reset akan dikirim ke email Anda.",
      },
      {
        "question": "Apa fungsi fitur Pin?",
        "answer":
            "Fitur Pin (ikon paku) digunakan untuk menempelkan catatan penting agar selalu muncul di urutan paling atas daftar, sehingga mudah ditemukan.",
      },
      {
        "question": "Saya menemukan Bug, harus lapor ke mana?",
        "answer":
            "Silakan hubungi tim pengembang kami melalui email di: notesapp@gmail.co.id. Kami sangat menghargai masukan Anda untuk meningkatkan aplikasi ini.",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Bantuan & FaQ',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final item = faqs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            clipBehavior: Clip.antiAlias, 
            child: ExpansionTile(
              shape: const Border(), 
              collapsedShape: const Border(),
              
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                item['question']!,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedAlignment: Alignment.centerLeft,
              children: [
                Text(
                  item['answer']!,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
