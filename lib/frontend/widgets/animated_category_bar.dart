// lib/frontend/widgets/animated_category_bar.dart

import 'package:flutter/material.dart';

class AnimatedCategoryBar extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;

  const AnimatedCategoryBar({
    Key? key,
    required this.categories,
    required this.selectedIndex,
    required this.onTap,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.black,
    this.backgroundColor = Colors.black87,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: LayoutBuilder(builder: (ctx, constraints) {
        final totalW = constraints.maxWidth;
        final count  = categories.length;
        final cellW  = totalW / count;

        return Stack(
          children: [
            // Плавающий фон
            AnimatedPositioned(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutQuint,
              left: cellW * selectedIndex + 4,
              top: 4,
              width: cellW - 8,
              height: 38,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutQuint,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            // Сам Row с кнопками
            Row(
              children: List.generate(count, (i) {
                final isSel = i == selectedIndex;
                return SizedBox(
                  width: cellW,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => onTap(i),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 400),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          color: isSel ? activeColor : inactiveColor,
                        ),
                        child: Text(categories[i]),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
