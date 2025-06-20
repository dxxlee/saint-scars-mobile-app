// lib/widgets/app_scaffold.dart
import 'package:flutter/material.dart';
import 'app_drawer.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // вот наш кастомный Drawer
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: false,
        actions: [
          // гамбургер-иконка справа
          Builder(builder: (ctx) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            );
          }),
          if (actions != null) ...actions!,
        ],
      ),
      body: body,
    );
  }
}
