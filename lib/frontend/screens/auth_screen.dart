import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override Widget build(BuildContext c) {
    return DefaultTabController(
      length: 2, child: Scaffold(
      appBar: AppBar(title: const Text('Fashion Hub'), bottom: const TabBar(tabs: [
        Tab(text: 'Login'), Tab(text: 'Register')
      ])),
      body: const TabBarView(children: [
        LoginScreen(),
        RegisterScreen(),
      ]),
    ),
    );
  }
}
