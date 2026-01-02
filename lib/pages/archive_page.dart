import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notesapp/services/firestore_service.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isGridView = false;
  String _selectedCategory = 'Semua';
  final List<String> _categories = [
    'Semua',
    'Pribadi',
    'Pekerjaan',
    'Ide',
    'Penting',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catatan Arsip"),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Arsip Anda',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade700
                              : Colors.grey.shade200,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isGridView
                              ? Icons.view_agenda_outlined
                              : Icons.grid_view_rounded,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.grey.shade700,
                          size: 24,
                        ),
                        onPressed: () {
                          setState(() {
                            _isGridView = !_isGridView;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
