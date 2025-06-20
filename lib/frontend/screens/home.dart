// lib/frontend/screens/home.dart

import 'package:clothing_store/frontend/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/category_card.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/animated_category_bar.dart';
import '../widgets/image_carousel.dart';
import '../widgets/best_seller_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required void Function(bool light) changeTheme,
    required void Function(int idx) changeColor,
    required ColorSelection colorSelected,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  int _selectedCategory = 0;
  int _carouselIndex    = 0;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _matchesCategory(Product p, List<String> cats) {
    if (_selectedCategory == 0) return true;
    final cat = cats[_selectedCategory].toLowerCase();
    return p.category.toLowerCase() == cat;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Локализованные категории
    final categories = <String>[
      l10n.categoryAll,
      l10n.categoryMens,
      l10n.categoryWomens,
      l10n.categoryShoes,
      l10n.categoryPerfumes,
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Поиск + Фильтр
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            decoration: InputDecoration(
                              hintText: l10n.searchHint,
                              border: InputBorder.none,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const Icon(Icons.mic, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {/* TODO: open filters */},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Анимированная панель категорий
            AnimatedCategoryBar(
              categories: categories,
              selectedIndex: _selectedCategory,
              onTap: (i) => setState(() => _selectedCategory = i),
              backgroundColor: Colors.indigo,
              activeColor: Colors.white,
              inactiveColor: Colors.black,
            ),

            const SizedBox(height: 16),

            // Карусель
            SizedBox(
              height: 180,
              child: ImageCarousel(
                imageUrls: const [
                  'https://img.myshopline.com/image/store/1674805255704/E-SHOP-ID-HP-BANNER-PC-1920x650-HERO-2x-(2).jpeg?w=3840&h=1300&q=100',
                  'https://img.freepik.com/premium-photo/twins-flaunt-their-fashion-denim-outfits-trendy-sneakers-studio_1326977-11410.jpg?w=1380',
                  'https://img.freepik.com/free-photo/fashion-shoes-sneakers_1203-7529.jpg?t=st=1746799245~exp=1746802845~hmac=6ae1470d9f095e9d770fccc8dca4302938a782a0f4785c79599852a48432cfd5&w=1380',
                ],
                onPageChanged: (idx) => setState(() => _carouselIndex = idx),
              ),
            ),
            const SizedBox(height: 16),

            // Сетка бестселлеров
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: ProductService.streamProducts(),
                builder: (ctx, snap) {
                  final all = snap.data ?? [];
                  final filtered = all
                      .where((p) => _matchesCategory(p, categories))
                      .where((p) => p.name
                      .toLowerCase()
                      .contains(_searchCtrl.text.toLowerCase()))
                      .toList();

                  if (filtered.isEmpty) {
                    return Center(child: Text(l10n.noProductsFound));
                  }

                  return GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      return BestSellerCard(
                        product: filtered[i],
                        onTap: () => GoRouter.of(context)
                            .push('/product', extra: filtered[i]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
