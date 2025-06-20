import 'package:flutter/material.dart';
import '../constants.dart';

class ColorButton extends StatelessWidget {
  final void Function(int) changeColor;
  final ColorSelection colorSelected;

  const ColorButton({
    Key? key,
    required this.changeColor,
    required this.colorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(
        Icons.color_lens_outlined,
        color: Theme.of(context).iconTheme.color,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) {
        return List.generate(ColorSelection.values.length, (index) {
          final currentColor = ColorSelection.values[index];
          return PopupMenuItem<int>(
            value: index,
            enabled: currentColor != colorSelected,
            child: Row(
              children: [
                Icon(Icons.circle, color: currentColor.color, size: 20),
                const SizedBox(width: 10),
                Text(currentColor.label),
              ],
            ),
          );
        });
      },
      onSelected: changeColor,
    );
  }
}
