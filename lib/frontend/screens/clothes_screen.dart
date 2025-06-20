// lib/frontend/screens/clothes_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/category_card.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/animated_category_bar.dart';
import '../widgets/best_seller_card.dart';

enum SortOption { nameAsc, nameDesc, priceAsc, priceDesc }

class ClothesScreen extends StatefulWidget {
  const ClothesScreen({Key? key}) : super(key: key);

  @override
  State<ClothesScreen> createState() => _ClothesScreenState();
}

class _ClothesScreenState extends State<ClothesScreen>
    with SingleTickerProviderStateMixin {
  final _searchCtrl = TextEditingController();
  int _selectedCategory = 0;
  SortOption _sortOption = SortOption.nameAsc;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _matches(Product p, List<String> cats) {
    final q = _searchCtrl.text.toLowerCase();
    if (q.isNotEmpty && !p.name.toLowerCase().contains(q)) return false;

    if (_selectedCategory > 0 &&
        p.category.toLowerCase() != cats[_selectedCategory].toLowerCase())
      return false;

    return true;
  }

  List<Product> _apply(List<Product> list) {
    final filtered = list.where((p) => _matches(p, _categories)).toList();
    filtered.sort((a, b) {
      switch (_sortOption) {
        case SortOption.nameAsc:
          return a.name.compareTo(b.name);
        case SortOption.nameDesc:
          return b.name.compareTo(a.name);
        case SortOption.priceAsc:
          return (a.discountedPrice ?? a.price)
              .compareTo(b.discountedPrice ?? b.price);
        case SortOption.priceDesc:
          return (b.discountedPrice ?? b.price)
              .compareTo(a.discountedPrice ?? a.price);
      }
    });
    return filtered;
  }

  // временное хранение локализованных категорий
  late List<String> _categories;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // инициализируем списки строк из локализации
    _categories = [
      l10n.categoryAll,
      l10n.categoryMens,
      l10n.categoryWomens,
      l10n.categoryShoes,
      l10n.categoryPerfumes,
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // SEARCH & SORT
        Row(children: [
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 12),
          DropdownButton<SortOption>(
            value: _sortOption,
            items: [
              DropdownMenuItem(
                value: SortOption.nameAsc,
                child: Text(l10n.sortNameAsc),
              ),
              DropdownMenuItem(
                value: SortOption.nameDesc,
                child: Text(l10n.sortNameDesc),
              ),
              DropdownMenuItem(
                value: SortOption.priceAsc,
                child: Text(l10n.sortPriceAsc),
              ),
              DropdownMenuItem(
                value: SortOption.priceDesc,
                child: Text(l10n.sortPriceDesc),
              ),
            ],
            onChanged: (v) => setState(() => _sortOption = v!),
          ),
        ]),

        const SizedBox(height: 16),

        // CATEGORIES
        AnimatedCategoryBar(
          categories: _categories,
          selectedIndex: _selectedCategory,
          onTap: (i) => setState(() => _selectedCategory = i),
          backgroundColor: Colors.indigo,
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),

        const SizedBox(height: 16),

        // GRID OF PRODUCTS
        Expanded(
          child: StreamBuilder<List<Product>>(
            stream: ProductService.streamProducts(),
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset(
                    'assets/lottie/loading.json',
                    width: 100,
                    repeat: true,
                  ),
                );
              }
              if (snap.hasError) {
                return Center(
                  child: Text('${l10n.errorPrefix} ${snap.error}'),
                );
              }
              final prods = _apply(snap.data!);
              if (prods.isEmpty) {
                return Center(child: Text(l10n.noProductsFound));
              }
              return GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: prods.length,
                itemBuilder: (ctx, i) {
                  final p = prods[i];
                  // staggered entrance animation
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 300 + i * 50),
                    builder: (c, v, child) {
                      return Opacity(
                        opacity: v,
                        child: Transform.translate(
                          offset: Offset(0, 50 * (1 - v)),
                          child: child,
                        ),
                      );
                    },
                    child: GestureDetector(
                      child: Hero(
                        tag: 'product-image-${p.id}',
                        child: BestSellerCard(
                          product: p,
                          onTap: () =>
                              context.push('/product', extra: p),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
