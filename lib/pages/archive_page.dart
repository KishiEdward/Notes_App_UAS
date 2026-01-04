import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notesapp/models/note_model.dart';
import 'package:notesapp/pages/note_editor_page.dart';
import 'package:notesapp/services/firestore_service.dart';
import 'package:notesapp/utils/markdown_helper.dart';
import 'package:notesapp/utils/notification_helper.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isGridView = false;
  String _selectedCategory = '';
  final List<String> _categories = ['Pribadi', 'Pekerjaan', 'Ide', 'Penting'];

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    labelStyle: GoogleFonts.poppins(
                      color: isSelected
                          ? Colors.white
                          : (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.grey.shade700),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedCategory = selected ? category : '';
                      });
                    },
                    backgroundColor: Theme.of(context).cardColor,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300),
                      ),
                    ),
                    elevation: 0,
                    pressElevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Note>>(
              stream: _firestoreService.getArchivedNotesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final archivedNotes = snapshot.data ?? [];

                final filteredNotes = archivedNotes.where((note) {
                  if (_selectedCategory.isEmpty) return true;
                  return note.category == _selectedCategory;
                }).toList();

                if (filteredNotes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.archive_rounded,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedCategory.isEmpty
                              ? "Belum ada catatan arsip"
                              : "Tidak ada catatan arsip di '$_selectedCategory'",
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      'Daftar Catatan Arsip',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_isGridView)
                      MasonryGridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) =>
                            _buildNoteItem(filteredNotes[index]),
                      )
                    else
                      Column(
                        children: filteredNotes
                            .map((note) => _buildNoteItem(note))
                            .toList(),
                      ),
                    const SizedBox(height: 100),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteItem(Note note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onLongPress: () {
            _showNoteOptions(context, note);
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteEditorPage(note: note),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        note.title.isNotEmpty ? note.title : 'Tanpa Judul',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color(0xFF2D3436),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (note.content.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  MarkdownHelper.buildPreview(
                    note.content,
                    maxLines: 2,
                    context: context,
                  ),
                ],
                const SizedBox(height: 8),
                if (note.category.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      note.category,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNoteOptions(BuildContext context, Note note) {
    final parentContext = context;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.unarchive_rounded,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    'Kembalikan dari Arsip',
                    style: GoogleFonts.poppins(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await _firestoreService.toggleArchive(
                      note.id,
                      note.isArchived,
                    );
                    if (parentContext.mounted) {
                      showTopNotification(
                        parentContext,
                        'Catatan dikembalikan dari arsip',
                        color: Colors.green.shade600,
                      );
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    'Pindahkan ke Sampah',
                    style: GoogleFonts.poppins(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await _firestoreService.moveToTrash(note.id);
                    if (parentContext.mounted) {
                      showTopNotification(
                        parentContext,
                        'Catatan dipindahkan ke sampah',
                        color: Colors.red.shade600,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
