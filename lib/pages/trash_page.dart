import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notesapp/models/note_model.dart';
import 'package:notesapp/services/firestore_service.dart';
import 'package:notesapp/utils/notification_helper.dart';
import 'package:notesapp/utils/markdown_helper.dart';
import 'package:notesapp/pages/trash_note_view_page.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final Set<String> _selectedNoteIds = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _runAutoCleanup();
  }

  Future<void> _runAutoCleanup() async {
    final int deletedCount = await _firestoreService.cleanupOldTrashedNotes();

    if (deletedCount > 0 && mounted) {
      showTopNotification(
        context,
        "$deletedCount catatan kadaluarsa dihapus otomatis",
        color: Colors.red.shade600,
      );
    }
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedNoteIds.contains(id)) {
        _selectedNoteIds.remove(id);
        if (_selectedNoteIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedNoteIds.add(id);
      }
    });
  }

  void _selectAll(List<Note> notes) {
    setState(() {
      if (_selectedNoteIds.length == notes.length) {
        _selectedNoteIds.clear();
        _isSelectionMode = false;
      } else {
        _selectedNoteIds.addAll(notes.map((e) => e.id));
      }
    });
  }

  Future<void> _restoreSelected() async {
    final count = _selectedNoteIds.length;

    if (mounted) {
      showTopNotification(
        context,
        "$count catatan dipulihkan",
        color: Colors.green.shade600,
      );
    }

    for (var id in _selectedNoteIds) {
      await _firestoreService.restoreFromTrash(id);
    }

    _exitSelectionMode();
  }

  Future<void> _deleteSelectedPermanently() async {
    final count = _selectedNoteIds.length;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Permanen?'),
        content: Text('Anda akan menghapus $count catatan selamanya.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (mounted) {
        showTopNotification(
          context,
          "$count catatan dihapus permanen",
          color: Colors.red.shade600,
        );
      }

      for (var id in _selectedNoteIds) {
        await _firestoreService.deleteNote(id);
      }

      _exitSelectionMode();
    }
  }

  void _exitSelectionMode() {
    if (mounted) {
      setState(() {
        _selectedNoteIds.clear();
        _isSelectionMode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: StreamBuilder<List<Note>>(
            stream: _firestoreService.getNotesStream(),
            builder: (context, snapshot) {
              final allTrashNotes =
                  snapshot.data
                      ?.where((note) => note.isTrashed == true)
                      .toList() ??
                  [];

              return Row(
                children: [
                  if (_isSelectionMode) ...[
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _exitSelectionMode,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedNoteIds.length} Dipilih',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _selectAll(allTrashNotes),
                      child: Text(
                        _selectedNoteIds.length == allTrashNotes.length
                            ? 'Batal Semua'
                            : 'Pilih Semua',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ] else ...[
                    Text(
                      'Sampah',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            size: 16,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Deleted",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.red.shade400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),

        Expanded(
          child: StreamBuilder<List<Note>>(
            stream: _firestoreService.getNotesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final trashNotes =
                  snapshot.data
                      ?.where((note) => note.isTrashed == true)
                      .toList() ??
                  [];

              if (trashNotes.isEmpty) {
                if (_isSelectionMode) {
                  Future.delayed(Duration.zero, () {
                    if (mounted) _exitSelectionMode();
                  });
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_sweep_outlined,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Tong sampah kosong",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return Stack(
                children: [
                  MasonryGridView.count(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      _isSelectionMode ? 100 : 20,
                    ),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemCount: trashNotes.length,
                    itemBuilder: (context, index) {
                      final note = trashNotes[index];
                      return _buildTrashItem(note);
                    },
                  ),

                  if (_isSelectionMode)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton.icon(
                                onPressed: _restoreSelected,
                                icon: const Icon(
                                  Icons.restore,
                                  color: Colors.green,
                                ),
                                label: Text(
                                  "Pulihkan (${_selectedNoteIds.length})",
                                  style: GoogleFonts.poppins(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: _deleteSelectedPermanently,
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                                label: Text(
                                  "Hapus (${_selectedNoteIds.length})",
                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrashItem(Note note) {
    final isSelected = _selectedNoteIds.contains(note.id);

    String expirytext = "";
    if (note.trashedAt != null) {
      final daysInTrash = DateTime.now().difference(note.trashedAt!).inDays;
      final daysLeft = 7 - daysInTrash;

      if (daysLeft > 0) {
        expirytext = "Hapus otomatis hari ini";
      } else {
        expirytext = "$daysLeft hari lagi dihapus otomatis";
      }
    }

    return InkWell(
      onLongPress: () {
        if (!_isSelectionMode) {
          setState(() {
            _isSelectionMode = true;
            _selectedNoteIds.add(note.id);
          });
        }
      },
      onTap: () {
        if (_isSelectionMode) {
          _toggleSelection(note.id);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrashNoteViewPage(note: note),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title.isNotEmpty ? note.title : 'Tanpa Judul',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_isSelectionMode)
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected
                        ? Colors.blueAccent
                        : Colors.grey.shade300,
                    size: 20,
                  ),
              ],
            ),

            if (note.trashedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  expirytext,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            if (note.content.isNotEmpty) ...[
              const SizedBox(height: 8),
              MarkdownHelper.buildPreview(
                note.content,
                maxLines: 3,
                context: context,
              ),
            ],

            if (!_isSelectionMode) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      if (mounted) {
                        showTopNotification(
                          context,
                          "Catatan dipulihkan",
                          color: Colors.green.shade600,
                        );
                      }
                      await _firestoreService.restoreFromTrash(note.id);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Tooltip(
                        message: "Kembalikan",
                        child: Icon(
                          Icons.restore_rounded,
                          color: Colors.green.shade600,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _showDeleteOneConfirmDialog(note.id),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Tooltip(
                        message: "Hapus Permanen",
                        child: Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.red.shade400,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDeleteOneConfirmDialog(String id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Hapus Permanen?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Catatan ini akan hilang selamanya.',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              if (mounted) {
                showTopNotification(
                  context,
                  "Catatan dihapus permanen",
                  color: Colors.red.shade600,
                );
              }

              await _firestoreService.deleteNote(id);
            },
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
