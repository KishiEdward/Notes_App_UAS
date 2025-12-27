import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        "question": "Apa fungsi tombol kategori di atas?",
        "answer":
            "Tombol seperti 'Pribadi', 'Pekerjaan', atau 'Ide' berfungsi untuk memfilter catatan. Klik salah satu tombol untuk hanya menampilkan catatan dari kategori tersebut.",
      },
      {
        "question": "Bagaimana cara mengubah tampilan?",
        "answer":
            "Anda bisa mengubah tampilan daftar catatan menjadi kotak-kotak (Grid) atau daftar memanjang (List) dengan menekan ikon kotak di pojok kanan atas layar utama.",
      },
      {
        "question": "Apa itu ikon paku (Pin)?",
        "answer":
            "Ikon paku digunakan untuk menyematkan catatan penting agar selalu muncul di urutan paling atas, sehingga tidak tertimbun oleh catatan baru.",
      },
      {
        "question": "Cara mencari catatan lama?",
        "answer":
            "Gunakan ikon kaca pembesar (Search) di menu bawah. Ketik kata kunci judul atau isi catatan untuk menemukannya dengan cepat.",
      },
      {
        "question": "Bagaimana jika catatan terhapus?",
        "answer":
            "Jangan panik. Catatan yang dihapus akan masuk ke menu 'Sampah' (ikon tong sampah di menu bawah). Anda bisa memulihkannya kembali dari sana.",
      },
      {
        "question": "Bagaimana cara mengaktifkan mode gelap?",
        "answer":
            "Mode gelap atau dark mode dapat diaktifkan di menu settings. Cari opsi 'Dark Mode' lalu tap sekali dan anda akan mengaktifkan mode gelap.",
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

              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
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
