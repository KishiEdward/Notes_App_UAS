import 'package:flutter/material.dart';
import 'package:notesapp/models/template_model.dart';
import 'package:notesapp/pages/note_editor_page.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({super.key});

  static final List<NoteTemplate> _templates = [
    NoteTemplate(
      title: 'Catatan Cepat',
      content: '', 
      category: 'Pribadi',
      icon: Icons.edit_note,
      color: Colors.pink[50]!,
      rating: '4.8',
    ),
    NoteTemplate(
      title: 'Daftar To-do sederhana',
      content: '- [ ] \n- [ ] \n- [ ] ',
      category: 'Pekerjaan',
      icon: Icons.check_circle_outline,
      color: Colors.blue[50]!,
      rating: '4.9',
    ),
    NoteTemplate(
      title: 'Jurnal sederhana',
      content: 'Tanggal: \n\nHal yang saya syukuri hari ini:\n1. \n2. \n3. \n\nCerita hari ini:\n',
      category: 'Pribadi',
      icon: Icons.book,
      color: Colors.purple[50]!,
      rating: '5.0',
    ),
    NoteTemplate(
      title: '1:1 Catatan',
      content: 'Agenda:\n1. \n2. \n\nCatatan Diskusi:\n- \n\nTindak Lanjut:\n- [ ] ',
      category: 'Pekerjaan',
      icon: Icons.people_outline,
      color: Colors.indigo[50]!,
      rating: '5.0',
    ),
    NoteTemplate(
      title: 'Daftar tugas mingguan sederhana',
      content: '# Senin\n- [ ] \n\n# Selasa\n- [ ] \n\n# Rabu\n- [ ] \n\n# Kamis\n- [ ] \n\n# Jumat\n- [ ] ',
      category: 'Pekerjaan',
      icon: Icons.list_alt,
      color: Colors.teal[50]!,
      rating: '5.0',
    ),
  ];

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
              
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
      
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                      
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

        
                Row(
                  children: [
                    Expanded(
                      child: _buildMainCategoryCard(
                        'Kehidupan',
                        Icons.local_florist, 
                        const Color(0xFFFFF9E6), 
                        const Color(0xFFFFA000),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMainCategoryCard(
                        'Pekerjaan',
                        Icons.show_chart,
                        const Color(0xFFF0F7FF), 
                        const Color(0xFF2196F3), 
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),


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


                 ..._templates.map((template) => _buildTemplateItem(context, template)).toList(),

                const SizedBox(height: 24),


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

  Widget _buildTemplateItem(BuildContext context, NoteTemplate template) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteEditorPage(
              initialTitle: template.title,
              initialContent: template.content,
              initialCategory: template.category,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
  
            Container(
              width: 100,
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(12),
              ),
  
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                           Container(width: 20, height: 20, color: template.color),
                           const SizedBox(height: 8),
                           Container(height: 4, width: 40, color: Colors.grey[300]),
                           const SizedBox(height: 4),
                           Container(height: 4, width: 60, color: Colors.grey[300]),
                           const SizedBox(height: 4),
                           Container(height: 4, width: 30, color: Colors.grey[300]),
                           
                           const Padding(padding: EdgeInsets.only(top: 20)),
  
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
                      Icon(Icons.description_outlined, size: 16, color: Colors.grey[800]),
                       const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          template.title,
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
                        template.rating,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 70),
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
