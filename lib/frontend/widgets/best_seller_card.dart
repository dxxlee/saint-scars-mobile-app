import 'package:flutter/material.dart';
import '../models/product.dart';

class BestSellerCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const BestSellerCard({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final original = product.price;
    final discounted = product.discountedPrice ?? original;
    final discountPercent = original > discounted
        ? ((original - discounted) / original * 100).round()
        : 0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: product.imageUrl.startsWith('http')
                  ? Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              )
                  : Image.asset(
                product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // name
          Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          // price row
          Row(
            children: [
              Text(
                '\$$discounted',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: discountPercent > 0 ? Colors.red : null,
                ),
              ),
              if (discountPercent > 0) ...[
                const SizedBox(width: 6),
                Text(
                  '\$$original',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '-$discountPercent%',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
