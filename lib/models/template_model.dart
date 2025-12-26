import 'package:flutter/material.dart';

class NoteTemplate {
  final String title;
  final String content;
  final String category;
  final IconData icon;
  final Color color;
  final String rating;

  NoteTemplate({
    required this.title,
    required this.content,
    required this.category,
    required this.icon,
    required this.color,
    required this.rating,
  });
}
