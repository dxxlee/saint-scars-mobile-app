import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404 Not Found')),
      body: const Center(
        child: Text(
          'Page not found!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
