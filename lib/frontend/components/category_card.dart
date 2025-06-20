import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.label,
    this.selected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? Theme.of(context).primaryColor
        : Theme.of(context).cardColor;
    final fg = selected
        ? Colors.white
        : Theme.of(context).textTheme.bodyLarge!.color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
