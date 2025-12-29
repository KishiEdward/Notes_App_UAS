import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/models/note_model.dart';
import 'package:notesapp/services/firestore_service.dart';
import 'package:notesapp/utils/notification_helper.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? note;

  final String? initialTitle;
  final String? initialContent;
  final String? initialCategory;

  const NoteEditorPage({
    super.key,
    this.note,
    this.initialTitle,
    this.initialContent,
    this.initialCategory,
  });

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String _selectedCategory = 'Pribadi';
  bool _isPinned = false;
  DateTime? _reminderDate;
  final List<String> _categories = ['Pribadi', 'Pekerjaan', 'Ide', 'Penting'];
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.note?.title ?? widget.initialTitle ?? '',
    );
    _contentController = TextEditingController(
      text: widget.note?.content ?? widget.initialContent ?? '',
    );
    _selectedCategory = widget.note?.category ?? widget.initialCategory ?? 'Pribadi';
    _isPinned = widget.note?.isPinned ?? false;
    _reminderDate = widget.note?.reminderDate;
    if (!_categories.contains(_selectedCategory)) {
      _selectedCategory = 'Pribadi';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      if (widget.note != null) {
        await _firestoreService.deleteNote(widget.note!.id);
      }
      return;
    }

    if (widget.note == null) {
      await _firestoreService.addNote(
        title,
        content,
        _selectedCategory,
        _isPinned,
        _reminderDate,
      );
    } else {
      await _firestoreService.updateNote(
        widget.note!.id,
        title,
        content,
        _selectedCategory,
        _isPinned,
        _reminderDate,
      );
    }
  }

  Future<void> _showReminderPicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _reminderDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_reminderDate ?? DateTime.now()),
      );

      if (time != null) {
        setState(() {
          _reminderDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _handleBack() async {
    await _saveNote();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _saveNote();
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            onPressed: _handleBack,
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: _isPinned ? Colors.black87 : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPinned = !_isPinned;
                });
              },
            ),
            IconButton(
              icon: Icon(
                _reminderDate != null ? Icons.alarm : Icons.alarm_add_outlined,
                color: _reminderDate != null ? Colors.blueAccent : Colors.grey,
              ),
              onPressed: _showReminderPicker,
            ),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.blueAccent),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                await _saveNote();
                if (mounted) Navigator.pop(context);
              },
            ),

            if (widget.note != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pindahkan ke Sampah?'),
                      content: const Text(
                        'Catatan ini bisa dikembalikan lagi nanti.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            'Batal',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Pindahkan',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await _firestoreService.moveToTrash(widget.note!.id);
                    if (mounted) Navigator.pop(context);
                    showTopNotification(
                      context,
                      "Catatan ini dipindahkan ke sampah",
                      color: Colors.red.shade600,
                    );
                  }
                },
              ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Judul',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black38),
                  ),
                  maxLines: 1,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: ChoiceChip(
                          label: Text(category),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          selectedColor: Colors.black87,
                          backgroundColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none,
                          ),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Mulai mengetik...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
