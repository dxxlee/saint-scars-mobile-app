import 'package:flutter/material.dart';
import '../models/clothing_category.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../constants.dart';

class ProductDetailScreen extends StatelessWidget {
  final ClothingCategory category;

  const ProductDetailScreen({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // filter logic here or fetch only this category…
    return Scaffold(
      appBar: AppBar(title: Text(category.title)),
      body: FutureBuilder<Product>(
        future: ProductService.getById(category.title), // or pass an ID
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final p = snap.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(p.imageUrl, fit: BoxFit.cover),
                ),
                const SizedBox(height: defaultPadding),
                Text(p.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('\$${p.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: defaultPadding),
                Text(p.description),
                // …and so on
              ],
            ),
          );
        },
      ),
    );
  }
}
