// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // получаем текущий путь
    final String location = GoRouter.of(context).location;

    // сопоставляем пути с индексами
    int currentIndex = 0;
    if (location.startsWith('/wishlist')) {
      currentIndex = 1;
    } else if (location.startsWith('/cart')) {
      currentIndex = 2;
    } else if (location.startsWith('/profile')) {
      currentIndex = 3;
    }

    // пункты меню
    final items = <_DrawerItem>[
      const _DrawerItem(icon: Icons.home_outlined,   label: 'Home',     route: '/'),
      const _DrawerItem(icon: Icons.star_border,     label: 'Wishlist', route: '/wishlist'),
      const _DrawerItem(icon: Icons.add_business,     label: 'All Clothes', route: '/clothes-screen'),
      const _DrawerItem(icon: Icons.shopping_bag_outlined, label: 'Cart',      route: '/cart'),
      const _DrawerItem(icon: Icons.person_outline,  label: 'Account',  route: '/profile'),
    ];

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // заголовок
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: Text(
                'Fashion Hub',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // элементы
            for (var i = 0; i < items.length; i++)
              ListTile(
                leading: Icon(
                  items[i].icon,
                  color: i == currentIndex
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  items[i].label,
                  style: TextStyle(
                    color: i == currentIndex
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: i == currentIndex ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop(); // закрываем Drawer
                  if (location != items[i].route) {
                    GoRouter.of(context).go(items[i].route);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem {
  final IconData icon;
  final String label;
  final String route;
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
