// lib/frontend/constants.dart

import 'package:flutter/material.dart';

/// Отступ по умолчанию
const double defaultPadding = 16.0;

/// Основной цвет (можете убрать, если не нужен)
const Color primaryColor = Colors.white;

/// Акцентные цвета приложения
enum ColorSelection {
  deepPurple('Deep Purple', Colors.deepPurple),
  purple('Purple', Colors.purple),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  final String label;
  final Color color;
  const ColorSelection(this.label, this.color);
}
