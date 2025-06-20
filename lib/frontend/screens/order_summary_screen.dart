// lib/frontend/screens/order_summary_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../models/order.dart';
import '../services/order_service.dart';
import '../models/cart_item.dart';

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({Key? key}) : super(key: key);

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  bool _showOngoing = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final containerBg =
    isDark ? theme.colorScheme.surfaceVariant : Colors.grey.shade300;
    final segmentBg = isDark ? theme.colorScheme.surface : Colors.white;
    final selectedTextColor = theme.colorScheme.onSurface;
    final unselectedTextColor =
    theme.colorScheme.onSurface.withOpacity(0.6);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: containerBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _buildSegment(
                    l10n.ongoing,
                    _showOngoing,
                    segmentBg,
                    selectedTextColor,
                    unselectedTextColor,
                  ),
                  _buildSegment(
                    l10n.completed,
                    !_showOngoing,
                    segmentBg,
                    selectedTextColor,
                    unselectedTextColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildOrderList(ongoing: _showOngoing, l10n: l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment(
      String label,
      bool selected,
      Color bg,
      Color fg,
      Color unf,
      ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _showOngoing = (label == AppLocalizations.of(context)!.ongoing)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? bg : Colors.transparent,
            borderRadius: selected ? BorderRadius.circular(8) : BorderRadius.zero,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? fg : unf,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList({required bool ongoing, required AppLocalizations l10n}) {
    return StreamBuilder<List<Order>>(
      stream: OrderService.streamOrders(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('${l10n.errorPrefix} ${snap.error}'));
        }
        final orders = snap.data ?? [];
        final filtered = ongoing ? orders : <Order>[];

        if (filtered.isEmpty) {
          return _EmptyOrders(ongoing: ongoing);
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: filtered.length,
          itemBuilder: (c, i) {
            final ci = filtered[i].items.first;
            return _OrderCard(
              item: ci,
              status: ongoing ? l10n.ongoing : l10n.completed,
              onTrack: () {/* TODO */},
            );
          },
        );
      },
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  final bool ongoing;
  const _EmptyOrders({Key? key, required this.ongoing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = ongoing ? l10n.noOngoingOrders : l10n.noCompletedOrders;
    final subtitle = ongoing
        ? l10n.emptyOngoingSubtitle
        : l10n.emptyCompletedSubtitle;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined,
                size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final CartItem item;
  final String status;
  final VoidCallback onTrack;

  const _OrderCard({
    Key? key,
    required this.item,
    required this.status,
    required this.onTrack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outline),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.imageUrl.startsWith('http')
                ? Image.network(item.imageUrl,
                width: 80, height: 80, fit: BoxFit.cover)
                : Image.asset(item.imageUrl,
                width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(item.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.secondaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(status,
                          style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.onSecondaryContainer,
                              fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${AppLocalizations.of(context)!.sizeLabel} ${item.size}',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant)),
                const SizedBox(height: 8),
                Text('\$${item.price.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onTrack,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              AppLocalizations.of(context)!.trackOrder,
              style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
