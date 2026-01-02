import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notesapp/models/note_model.dart';
import 'package:notesapp/pages/archive_page.dart';
import 'package:notesapp/pages/note_editor_page.dart';
import 'package:notesapp/pages/profile_page.dart';
import 'package:notesapp/pages/profile_team_page.dart';
import 'package:notesapp/pages/search_page.dart';
import 'package:notesapp/pages/template_page.dart';
import 'package:notesapp/pages/trash_page.dart';
import 'package:notesapp/services/auth_service.dart';
import 'package:notesapp/services/firestore_service.dart';
import 'package:notesapp/utils/notification_helper.dart';
import 'package:notesapp/utils/markdown_helper.dart';
import 'package:notesapp/pages/settings_page.dart';
import 'package:notesapp/pages/notification_page.dart';
import 'package:notesapp/services/notification_service.dart';
import 'package:notesapp/widgets/auth_wrapper.dart';
import 'package:notesapp/services/session_manager.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'Semua';
  bool _isGridView = false;
  final FirestoreService _firestoreService = FirestoreService();

  // Keys for Showcase
  final GlobalKey _addNoteKey = GlobalKey();
  final GlobalKey _notificationKey = GlobalKey();
  final GlobalKey _viewToggleKey = GlobalKey();

  final List<String> _categories = [
    'Semua',
    'Pribadi',
    'Pekerjaan',
    'Ide',
    'Penting',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkTutorial());
  }

  Future<void> _checkTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTutorial = prefs.getBool('has_seen_home_tutorial') ?? false;

    if (!hasSeenTutorial && mounted) {
      ShowCaseWidget.of(
        context,
      ).startShowCase([_addNoteKey, _viewToggleKey, _notificationKey]);
      await prefs.setBool('has_seen_home_tutorial', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: _buildBodyContent(user)),
      floatingActionButton: _selectedIndex == 3
          ? null
          : Showcase(
              key: _addNoteKey,
              title: 'Buat Catatan',
              description: 'Tap di sini untuk membuat catatan barumu!',
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NoteEditorPage(),
                    ),
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Theme.of(context).cardColor,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 0),
              _buildNavItem(Icons.search_rounded, 1),
              const SizedBox(width: 40),
              _buildNavItem(
                Icons.notifications_none_rounded,
                2,
                showcaseKey: _notificationKey,
                title: 'Notifikasi',
                description: 'Cek pengingat dan info terbaru di sini.',
              ),
              _buildNavItem(Icons.delete_outline_rounded, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent(User? user) {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent(user);
      case 1:
        return const SearchPage();
      case 2:
        return const NotificationPage();
      case 3:
        return const TrashPage();
      default:
        return _buildHomeContent(user);
    }
  }

  Widget _buildHomeContent(User? user) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _showUserMenu(context);
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey.shade200,
                  child: Text(
                    (user?.displayName?.isNotEmpty == true)
                        ? user!.displayName!.substring(0, 1).toUpperCase()
                        : 'U',
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo,',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showUserMenu(context);
                      },
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              user?.displayName ?? 'User',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
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
                    child: Showcase(
                      key: _viewToggleKey,
                      title: 'Ubah Tampilan',
                      description:
                          'Ganti tampilan catatanmu jadi List atau Grid.',
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
                  ),
                  const SizedBox(width: 8),
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
                        Icons.archive_outlined,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.grey.shade700,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ArchivePage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
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
                        Icons.group_rounded,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.grey.shade700,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileTeamPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
                      _selectedCategory = category;
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
            stream: _firestoreService.getNotesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final allNotes = snapshot.data ?? [];

              final filteredNotes = allNotes.where((note) {
                final isNotTrash = note.isTrashed == false;
                final isNotArchived = note.isArchived == false;
                final isCategoryMatch = _selectedCategory == 'Semua'
                    ? true
                    : note.category == _selectedCategory;

                return isNotTrash && isNotArchived && isCategoryMatch;
              }).toList();

              if (filteredNotes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notes_rounded,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedCategory == 'Semua'
                            ? "Belum ada catatan"
                            : "Tidak ada catatan di '$_selectedCategory'",
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
                    'Daftar Catatan',
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
                  const SizedBox(height: 24),
                  Divider(
                    color: Colors.grey.shade200,
                    thickness: 1,
                    height: 32,
                  ),
                  _buildTemplateCard(),
                  const SizedBox(height: 100),
                ],
              );
            },
          ),
        ),
      ],
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
            _showNoteContextMenu(context, note);
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              note.title.isNotEmpty
                                  ? note.title
                                  : 'Tanpa Judul',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : const Color(0xFF2D3436),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (note.isPinned)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.push_pin,
                                size: 16,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white70
                                    : Colors.black87,
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
                      if (note.category != 'All' && note.category != 'General')
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
                IconButton(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 20,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: () {
                    _showNoteOptions(context, note);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
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
      backgroundColor: Colors.white,
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

                    if (parentContext.mounted) {
                      showTopNotification(
                        parentContext,
                        "Catatan dipindahkan ke sampah",
                        color: Colors.red.shade600,
                      );
                    }

                    await _firestoreService.moveToTrash(note.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNoteContextMenu(BuildContext context, Note note) {
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
                    Icons.archive_rounded,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    'Arsipkan Note',
                    style: GoogleFonts.poppins(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    _showArchiveCategoryDialog(parentContext, note);
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
                    if (parentContext.mounted) {
                      showTopNotification(
                        parentContext,
                        "Catatan dipindahkan ke sampah",
                        color: Colors.red.shade600,
                      );
                    }
                    await _firestoreService.moveToTrash(note.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showArchiveCategoryDialog(BuildContext context, Note note) {
    final categories = ['Semua', 'Pribadi', 'Pekerjaan', 'Ide', 'Penting'];

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Theme.of(context).cardColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Kategori Arsip',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            Navigator.pop(dialogContext);
                            await _firestoreService.toggleArchive(
                              note.id,
                              note.isArchived,
                            );
                            if (context.mounted) {
                              showTopNotification(
                                context,
                                "Catatan berhasil diarsipkan",
                                color: Colors.green.shade600,
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.folder_rounded,
                                  color: Colors.blueAccent,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  category,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(dialogContext);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Batal',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTemplateCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TemplatePage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F2F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                color: Colors.black87,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              'Jelajahi templat',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    int index, {
    GlobalKey? showcaseKey,
    String? description,
    String? title,
  }) {
    final isSelected = _selectedIndex == index;
    Widget child = index == 2
        ? FutureBuilder<int>(
            future: NotificationService().getNotificationCount(),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    color: isSelected ? Colors.black87 : Colors.grey.shade400,
                    size: 28,
                  ),
                  if (count > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            count > 9 ? '9+' : count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          )
        : Icon(
            icon,
            color: isSelected
                ? (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87)
                : Colors.grey.shade400,
            size: 28,
          );

    if (showcaseKey != null) {
      child = Showcase(
        key: showcaseKey,
        title: title,
        description: description,
        child: child,
      );
    }

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(30),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }

  void _showUserMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded),
              title: Text(
                'Profile',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(
                'Settings',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.black87),
              title: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                await SessionManager().clearSession();
                await AuthService().signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const AuthWrapper(),
                    ),
                    (route) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
