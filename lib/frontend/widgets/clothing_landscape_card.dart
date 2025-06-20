import 'package:flutter/material.dart';
import '../models/product.dart';

class ClothingLandscapeCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ClothingLandscapeCard({Key? key, required this.product, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Делает карточку кликабельной
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 2,
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              title: Text(
                product.name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subtitle: Text(
                product.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: const Icon(Icons.shopping_bag),
            ),
          ],
        ),
      ),
    );
  }
}
