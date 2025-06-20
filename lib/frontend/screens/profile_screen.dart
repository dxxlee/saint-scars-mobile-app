// lib/frontend/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _confirmLogout(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.all(16),
        icon: const Icon(Icons.error_outline, size: 48, color: Colors.red),
        title: Text(l10n.logoutConfirmTitle, textAlign: TextAlign.center),
        content: Text(l10n.logoutConfirmContent, textAlign: TextAlign.center),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                AuthService.signOut();
                GoRouter.of(context).go('/');

              },
              child: Text(l10n.logoutYes),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.logoutNo),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fb.User? fbUser = fb.FirebaseAuth.instance.currentUser;
    final displayName = fbUser?.displayName ?? l10n.anonymous;
    final email       = fbUser?.email ?? '';
    final photoUrl    = fbUser?.photoURL;

    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 24),
          // Профильный блок
          Column(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                child: photoUrl == null
                    ? const Icon(Icons.person, size: 48, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 12),
              Text(displayName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(email, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),

          // Меню
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: Text(l10n.myOrders),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => GoRouter.of(context).go('/order-summary'),
          ),
          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l10n.myDetails),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {/* TODO */},
          ),
          // ListTile(
          //   leading: const Icon(Icons.home_outlined),
          //   title: Text(l10n.addressBook),
          //   trailing: const Icon(Icons.chevron_right),
          //   onTap: () {/* TODO */},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.credit_card_outlined),
          //   title: Text(l10n.paymentMethods),
          //   trailing: const Icon(Icons.chevron_right),
          //   onTap: () {/* TODO */},
          // ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l10n.settings),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => GoRouter.of(context).go('/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(l10n.notifications),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => GoRouter.of(context).go('/notifications'),
          ),
          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: Text(l10n.map),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => GoRouter.of(context).go('/map'),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.faqs),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => GoRouter.of(context).go('/faqs'),
          ),
          ListTile(
            leading: const Icon(Icons.headset_mic_outlined),
            title: Text(l10n.helpCenter),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => GoRouter.of(context).go('/help'),
          ),
          const Divider(height: 1),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }
}
