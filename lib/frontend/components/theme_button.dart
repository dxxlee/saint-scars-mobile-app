import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  final void Function(bool) changeThemeMode;

  const ThemeButton({
    Key? key,
    required this.changeThemeMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return IconButton(
      icon: isLight
          ? const Icon(Icons.dark_mode_outlined)
          : const Icon(Icons.light_mode_outlined),
      onPressed: () => changeThemeMode(!isLight),
    );
  }
}
