import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notesapp/models/template_model.dart';
import 'package:notesapp/pages/note_editor_page.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({super.key});

  static final List<NoteTemplate> _templates = [
    NoteTemplate(
      title: 'Catatan Cepat',
      content: '📝 **Catatan Cepat**\n\n💡 Ide utama:\n- \n\n✨ Detail penting:\n- \n- \n\n🔗 Referensi/Link:\n- ', 
      category: 'Pribadi',
      icon: Icons.edit_note,
      color: Colors.pink[50]!,
      rating: '4.8',
    ),
    NoteTemplate(
      title: 'Daftar To-do',
      content: '✅ **Target Hari Ini**\n\n🔴 Prioritas Tinggi\n- [ ] \n- [ ] \n\n🟡 Rutinitas\n- [ ] \n- [ ] \n\n🟢 Nanti Saja\n- [ ] ',
      category: 'Pekerjaan',
      icon: Icons.check_circle_outline,
      color: Colors.blue[50]!,
      rating: '4.9',
    ),
    NoteTemplate(
      title: 'Jurnal Harian',
      content: '📅 **Jurnal Harian**\n\nmood hari ini: 😐 / 🙂 / 🤩 / 😔\n\n🙏 **Moment Bersyukur**\n1. \n2. \n3. \n\n🌟 **Highlight Hari Ini**\nApa satu hal menarik yang terjadi?\n\n🧠 **Refleksi**\nApa yang saya pelajari hari ini?',
      category: 'Pribadi',
      icon: Icons.book,
      color: Colors.purple[50]!,
      rating: '5.0',
    ),
    NoteTemplate(
      title: '1:1 Meeting',
      content: '🤝 **1:1 Meeting**\n👤 Dengan: \n\n📋 **Agenda**\n1. \n2. \n3. \n\n💬 **Catatan Diskusi**\n- \n- \n\n🚀 **Action Items**\n- [ ] \n- [ ] ',
      category: 'Pekerjaan',
      icon: Icons.people_outline,
      color: Colors.indigo[50]!,
      rating: '5.0',
    ),
    NoteTemplate(
      title: 'Planner Mingguan',
      content: '🗓️ **Minggu Ini**\n🎯 Fokus Utama: \n\nMonday 🌑\n- [ ] \n\nTuesday 🌒\n- [ ] \n\nWednesday 🌓\n- [ ] \n\nThursday 🌔\n- [ ] \n\nFriday 🌕\n- [ ] \n\nWeekend 🏖️\n- [ ] ',
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


                MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemCount: _templates.length,
                  itemBuilder: (context, index) {
                    return _buildTemplateItem(context, _templates[index]);
                  },
                ),

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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: template.color.withOpacity(0.3),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: _buildVisualPreview(template),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    children: [
                      Icon(template.icon, size: 16, color: Colors.grey[800]),
                       const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          template.title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          template.category,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        template.rating,
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualPreview(NoteTemplate template) {
    if (template.title.contains('To-do')) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCheckRow(),
            const SizedBox(height: 8),
            _buildCheckRow(),
            const SizedBox(height: 8),
            _buildCheckRow(),
          ],
        ),
      );
    } else if (template.title.contains('Jurnal')) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('😐', style: TextStyle(fontSize: 14)),
              SizedBox(width: 4),
              Text('🙂', style: TextStyle(fontSize: 14)),
              SizedBox(width: 4),
              Text('🤩', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 4, width: 60, color: Colors.black12),
          const SizedBox(height: 4),
          Container(height: 4, width: 40, color: Colors.black12),
        ],
      );
    } else if (template.title.contains('Meeting')) {
       return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               CircleAvatar(radius: 8, backgroundColor: Colors.indigo[100]),
               const SizedBox(width: 8),
               CircleAvatar(radius: 8, backgroundColor: Colors.orange[100]),
            ],
          ),
          const SizedBox(height: 12),
           Container(height: 4, width: 50, color: Colors.black12),
           const SizedBox(height: 4),
           Container(height: 4, width: 50, color: Colors.black12),
        ],
      );
    } else if (template.title.contains('Planner')) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: List.generate(6, (index) => Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(4),
            ),
          )),
        ),
      );
    }
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 6, width: 60, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 6),
        Container(height: 4, width: 80, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 6),
        Container(height: 4, width: 50, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
      ],
    );
  }

  Widget _buildCheckRow() {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
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
