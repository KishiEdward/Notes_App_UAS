import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarkdownHelper {
  static List<Widget> parseContent(
    String content, {
    int maxLines = 2,
    required BuildContext context,
  }) {
    final lines = content.split('\\n');
    final widgets = <Widget>[];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    int displayedLines = 0;
    for (var line in lines) {
      if (displayedLines >= maxLines) break;
      
      if (line.trim().startsWith('- [ ]') || line.trim().startsWith('- [x]')) {
        final isChecked = line.trim().startsWith('- [x]');
        final text = line.replaceFirst(RegExp(r'- \[[x ]\]\s*'), '');
        
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 16,
                  color: isChecked ? Colors.green : (isDark ? Colors.grey.shade400 : Colors.grey),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      decoration: isChecked ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
        displayedLines++;
      } else if (line.trim().isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              line,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
        displayedLines++;
      }
    }
    
    return widgets;
  }
  
  static Widget buildPreview(
    String content, {
    int maxLines = 2,
    required BuildContext context,
  }) {
    final widgets = parseContent(content, maxLines: maxLines, context: context);
    
    if (widgets.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
