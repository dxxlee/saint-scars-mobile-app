import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationItem {
  final String title;
  final String subtitle;
  final IconData icon;
  NotificationItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  // Заготовка данных. В реале подгружайте из сервиса.
  Map<String, List<NotificationItem>> get _sections => {
    'Today': [
      NotificationItem(
          title: '30% Special Discount!',
          subtitle: 'Special promotion only valid today.',
          icon: Icons.local_offer_outlined),
    ],
    'Yesterday': [
      NotificationItem(
          title: 'Top Up E-wallet Successfully!',
          subtitle: 'You have top up your e-wallet.',
          icon: Icons.account_balance_wallet_outlined),
      NotificationItem(
          title: 'New Service Available!',
          subtitle: 'Now you can track order in real-time.',
          icon: Icons.location_on_outlined),
    ],
    'June 7, 2023': [
      NotificationItem(
          title: 'Credit Card Connected!',
          subtitle: 'Credit card has been linked.',
          icon: Icons.credit_card_outlined),
      NotificationItem(
          title: 'Account Setup Successfully!',
          subtitle: 'Your account has been created.',
          icon: Icons.person_add_alt_1_outlined),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            // Row(
            //   children: [
            //     IconButton(
            //       icon: const Icon(Icons.arrow_back),
            //       onPressed: () => GoRouter.of(context).pop(),
            //     ),
            //     const Expanded(
            //       child: Text(
            //         'Notifications',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            //       ),
            //     ),
            //   ],
            // ),

            const Divider(height: 1),

            // Список секций
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: _sections.entries.expand((entry) {
                  final section = entry.key;
                  final items = entry.value;
                  return [
                    // Заголовок секции
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        section,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    // Элементы
                    ...items.map((n) {
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(n.icon,
                                color: Theme.of(context).colorScheme.primary),
                            title: Text(n.title,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(n.subtitle),
                          ),
                          const Divider(height: 1, indent: 72),
                        ],
                      );
                    }),
                  ];
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
