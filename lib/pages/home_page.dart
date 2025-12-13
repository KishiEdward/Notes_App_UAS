import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notesapp/services/auth_service.dart';
import 'package:notesapp/pages/login_page.dart';
import 'package:notesapp/pages/profile_page.dart';
import 'package:notesapp/pages/template_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Sample notes data (empty for now)
  final List<Map<String, String>> _notes = [];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header with user profile
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // User avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFE0E0E0),
                    child: Text(
                      user?.displayName?.substring(0, 1).toUpperCase() ?? 'R',
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // User name with dropdown
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Show user menu
                        _showUserMenu(context);
                      },
                      child: Row(
                        children: [
                          Text(
                            user?.displayName ?? user?.email?.split('@')[0] ?? 'User',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF666666),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Menu button
                  IconButton(
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Color(0xFF666666),
                    ),
                    onPressed: () {
                      _showOptionsMenu(context);
                    },
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Section header: Privat
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Text(
                          'Privat',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF999999),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.more_horiz,
                            size: 20,
                            color: Color(0xFF999999),
                          ),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                            size: 20,
                            color: Color(0xFF999999),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Add new note'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),

                  // Note items
                  ..._notes.map((note) => _buildNoteItem(note)),

                  const SizedBox(height: 16),

                  // Divider
                  Divider(
                    color: Colors.grey[300],
                    thickness: 0.5,
                    height: 32,
                  ),

                  // Template card
                  _buildTemplateCard(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, 0),
                _buildNavItem(Icons.search, 1),
                _buildNavItem(Icons.inbox_outlined, 2),
                _buildNavItem(Icons.edit_outlined, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteItem(Map<String, String> note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening: ${note['title']}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              // Chevron
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFFCCCCCC),
              ),
              const SizedBox(width: 8),
              // Emoji
              Text(
                note['emoji'] ?? '📝',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),
              // Title
              Expanded(
                child: Text(
                  note['title'] ?? 'Untitled',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Menu
              IconButton(
                icon: const Icon(
                  Icons.more_horiz,
                  size: 18,
                  color: Color(0xFF999999),
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              // Add button
              IconButton(
                icon: const Icon(
                  Icons.add,
                  size: 18,
                  color: Color(0xFF999999),
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
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
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.grid_view_outlined,
                color: Color(0xFF999999),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Jelajahi templat',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF666666),
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        if (index == 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New note'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF333333) : const Color(0xFF999999),
          size: 26,
        ),
      ),
    );
  }

  void _showUserMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
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
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                await AuthService().signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
