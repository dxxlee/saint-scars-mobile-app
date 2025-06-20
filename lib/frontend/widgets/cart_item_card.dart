import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/cart_service.dart';

class CartItemCard extends StatelessWidget {
  /// Данные позиции
  final CartItem item;

  /// Детали продукта (для картинки и атрибутов)
  final Product product;

  /// Удаление позиции
  final VoidCallback? onDelete;

  /// Уменьшить количество
  final VoidCallback? onDecrement;

  /// Увеличить количество
  final VoidCallback? onIncrement;

  const CartItemCard({
    Key? key,
    required this.item,
    required this.product,
    this.onDelete,
    this.onDecrement,
    this.onIncrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Картинка
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: product.imageUrl.startsWith('http')
                ? Image.network(
              product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            )
                : Image.asset(
              product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // Описание + управление
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Название + delete
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon:
                      const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: onDelete ??
                              () => CartService.remove(item.productId),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Отображение размера
                Text(
                  '${l10n.sizeLabel}: ${item.size}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),

                // Отображение магазина
                Text(
                  '${l10n.storeLabel}: ${item.store}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),

                // Цена + кол-во
                Row(
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: onDecrement ??
                          (item.quantity > 1
                              ? () => CartService.updateQuantity(
                              item.productId, item.quantity - 1)
                              : null),
                    ),
                    Text('${item.quantity}'),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: onIncrement ??
                              () => CartService.updateQuantity(
                              item.productId, item.quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
