import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override Widget build(BuildContext c) => Scaffold(
    appBar: AppBar(title: const Text('Search')),
    body: const Center(child: Text('Страница поиска товаров')),
    drawer: const AppDrawer(),
  );
}