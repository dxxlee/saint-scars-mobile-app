import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  Widget _buildTile(BuildContext c, IconData icon, String label, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(c).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(c).dividerColor),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildTile(context, Icons.headset_mic_outlined,
                      'Customer Service', () {
                        // TODO: launch support chat
                      }),
                  // _buildTile(context, Icons.whatsapp, 'WhatsApp', () {
                  //   // TODO: launch whatsapp
                  // }),
                  _buildTile(context, Icons.language, 'Website', () {
                    // TODO: open website
                  }),
                  _buildTile(context, Icons.facebook, 'Facebook', () {
                    // TODO: open facebook
                  }),
                  // _buildTile(context, Icons.twitter, 'Twitter', () {
                  //   // TODO: open twitter
                  // }),
                  _buildTile(context, Icons.camera_alt, 'Instagram', () {
                    // TODO: open instagram
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
