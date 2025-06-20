import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);
  @override Widget build(BuildContext c) => Scaffold(
    appBar: AppBar(title: const Text('Wishlist')),
    body: const Center(child: Text('Здесь будут ваши избранные товары')),
    drawer: const AppDrawer(),
  );
}