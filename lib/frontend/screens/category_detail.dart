import 'package:flutter/material.dart';
import '../models/clothing_category.dart';

class CategoryDetail extends StatelessWidget {
  final ClothingCategory category;
  const CategoryDetail({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              category.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                category.description,
                style: textTheme.bodyLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                category.text,
                style: textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
