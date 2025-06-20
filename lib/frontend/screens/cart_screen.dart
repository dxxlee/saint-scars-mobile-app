// lib/frontend/screens/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../services/product_service.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // 1) Список товаров
        Expanded(
          child: StreamBuilder<List<CartItem>>(
            stream: CartService.streamCart(),
            builder: (ctx, cartSnap) {
              if (cartSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (cartSnap.hasError) {
                return Center(
                  child: Text('${l10n.errorPrefix} ${cartSnap.error}'),
                );
              }
              final items = cartSnap.data ?? [];
              if (items.isEmpty) {
                return Center(child: Text(l10n.cartEmpty));
              }

              return StreamBuilder<List<Product>>(
                stream: ProductService.streamProducts(),
                builder: (ctx, prodSnap) {
                  final products = prodSnap.data ?? [];
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 16),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final item = items[i];
                      final prod = products.firstWhere(
                            (p) => p.id == item.productId,
                        orElse: () => Product(
                          id: item.productId,
                          name: item.name,
                          description: '',
                          price: item.price,
                          discountedPrice: null,
                          imageUrl: item.imageUrl,
                          availableSizes: [],
                          availableStores: [], category: '',
                        ),
                      );
                      return CartItemCard(
                        item: item,
                        product: prod,
                        onDelete: () => CartService.remove(item.productId),
                        onDecrement: item.quantity > 1
                            ? () => CartService.updateQuantity(
                            item.productId, item.quantity - 1)
                            : null,
                        onIncrement: () => CartService.updateQuantity(
                            item.productId, item.quantity + 1),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),

        // 2) Итог и кнопка «Go To Checkout →»
        Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<List<CartItem>>(
            stream: CartService.streamCart(),
            builder: (ctx, snap) {
              final items = snap.data ?? [];
              final total = items.fold<double>(
                0,
                    (sum, it) => sum + it.price * it.quantity,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.cartTotal(total.toStringAsFixed(2)),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => GoRouter.of(context).go('/checkout'),
                      child: Text(l10n.checkoutButton, style: const TextStyle(fontSize: 16),),


                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
