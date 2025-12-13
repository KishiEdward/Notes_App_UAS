import 'package:flutter/material.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      // Logo placeholder or similar (optional based on image, looks like App Icon)
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                            // color: Colors.orange, // Placeholder for logo
                            ),
                          child: Image.asset('assets/images/logo.png', width: 24, height: 24, errorBuilder: (c,e,s) => const Icon(Icons.description, color: Colors.orange)),
                      ),
                      const Expanded(
                        child: Text(
                          'Templat',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, size: 20, color: Colors.black54),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                           BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                    ]
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Pencarian',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Categories Row
                Row(
                  children: [
                    Expanded(
                      child: _buildMainCategoryCard(
                        'Kehidupan',
                        Icons.local_florist, // Plant icon
                        const Color(0xFFFFF9E6), // Light yellow
                        const Color(0xFFFFA000), // Orange/Yellow accent
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMainCategoryCard(
                        'Pekerjaan',
                        Icons.show_chart,
                        const Color(0xFFF0F7FF), // Light blue
                        const Color(0xFF2196F3), // Blue accent
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // "Templat ramah seluler"
                Row(
                  children: [
                    Icon(Icons.phone_android, size: 20, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Templat ramah seluler',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),

                // Templates List
                _buildTemplateItem(
                  'Catatan Cepat',
                  '4,8',
                  Icons.edit_note,
                  Colors.pink[50]!,
                ),
                _buildTemplateItem(
                  'Daftar To-do sederhana',
                  '4,9',
                  Icons.check_circle_outline,
                   Colors.blue[50]!,
                ),
                _buildTemplateItem(
                  'Jurnal sederhana',
                  '5,0',
                  Icons.book,
                   Colors.purple[50]!,
                ),
                 _buildTemplateItem(
                  '1:1 Catatan',
                  '5,0',
                  Icons.people_outline,
                   Colors.indigo[50]!,
                ),
                 _buildTemplateItem(
                  'Daftar tugas mingguan sederhana',
                  '5,0',
                  Icons.list_alt,
                   Colors.teal[50]!,
                ),

                const SizedBox(height: 24),

                // "Kategori teratas"
                Row(
                  children: [
                    Icon(Icons.trending_up, size: 20, color: Colors.grey[600]),
                     const SizedBox(width: 8),
                    Text(
                      'Kategori teratas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildCategoryChip('Vision Boardx', Icons.auto_awesome, const Color(0xFFFFF9E6), Colors.orange),
                    _buildCategoryChip('AI', Icons.auto_fix_high, const Color(0xFFF0F7FF), Colors.blue),
                    _buildCategoryChip('Alat Berbasis AI', Icons.stars, const Color(0xFFF0F7FF), Colors.blue),
                    _buildCategoryChip('Startup', Icons.rocket_launch, const Color(0xFFF0F7FF), Colors.blue),
                    _buildCategoryChip('Operasi Startup', Icons.lightbulb, const Color(0xFFF0F7FF), Colors.blue),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCategoryCard(String title, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateItem(String title, String rating, IconData icon, Color placeholderColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
           BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for Template Preview Image
          Container(
            width: 100,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
            ),
              // Simulating the UI in screenshot
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                         Container(width: 20, height: 20, color: placeholderColor), // Icon placeholder
                         const SizedBox(height: 8),
                         Container(height: 4, width: 40, color: Colors.grey[300]), // Line
                         const SizedBox(height: 4),
                         Container(height: 4, width: 60, color: Colors.grey[300]), // Line
                         const SizedBox(height: 4),
                         Container(height: 4, width: 30, color: Colors.grey[300]), // Line
                         
                         const Padding(padding: EdgeInsets.only(top: 20)),
                         // Checklist simulation
                         Row(children: [Icon(Icons.check_box_outline_blank, size: 8, color: Colors.grey), SizedBox(width: 4), Container(height: 3, width: 40, color: Colors.grey[300])]),
                         SizedBox(height: 4),
                         Row(children: [Icon(Icons.check_box_outline_blank, size: 8, color: Colors.grey), SizedBox(width: 4), Container(height: 3, width: 30, color: Colors.grey[300])]),
                    ],
                )
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.description_outlined, size: 16, color: Colors.grey[800]), // Notion like icon
                     const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70), // Spacer to push "Gratis" down
                const Text(
                  'Gratis',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
