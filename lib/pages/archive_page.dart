import 'package:flutter/material.dart';
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
    );
  }
}
