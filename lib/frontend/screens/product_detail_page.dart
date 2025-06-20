// lib/frontend/screens/product_detail_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/review.dart';
import '../services/cart_service.dart';
import '../services/review_service.dart';
import '../widgets/animated_button.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  String _size = '';
  String _store = '';
  int _qty = 1;
  bool _adding = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {})); // rebuild to update + button

    final p = widget.product;
    _size = p.availableSizes.isNotEmpty ? p.availableSizes.first : '';
    _store = p.availableStores.isNotEmpty ? p.availableStores.first : '';
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _addToCart() async {
    setState(() => _adding = true);
    await Future.delayed(const Duration(milliseconds: 300));
    CartService.addToCart(CartItem(
      productId: widget.product.id,
      name: widget.product.name,
      imageUrl: widget.product.imageUrl,
      price: widget.product.discountedPrice ?? widget.product.price,
      quantity: _qty,
      size: _size,
      store: _store,
    ));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Added to cart')));
    context.pop();
  }

  Future<void> _showReviewDialog({Review? existing}) async {
    final isEditing = existing != null;
    final authorCtl = TextEditingController(text: existing?.author);
    final contentCtl = TextEditingController(text: existing?.content);
    int rating = existing?.rating ?? 5;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(isEditing ? 'Edit Review' : 'Add Review'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: authorCtl,
                decoration: const InputDecoration(labelText: 'Your Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentCtl,
                decoration: const InputDecoration(labelText: 'Review'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final star = i + 1;
                  return IconButton(
                    icon: Icon(
                      rating >= star ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => rating = star),
                  );
                }),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final r = Review(
                id: existing?.id ?? '',
                productId: widget.product.id,
                author: authorCtl.text.trim(),
                content: contentCtl.text.trim(),
                rating: rating,
                createdAt: DateTime.now(),
              );
              if (isEditing) {
                ReviewService.updateReview(r);
              } else {
                ReviewService.addReview(r);
              }
              Navigator.of(ctx).pop();
            },
            child: Text(isEditing ? 'Save' : 'Post'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(BuildContext context) {
    final p = widget.product;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Hero(
            tag: 'product-image-${p.id}',
            child: p.imageUrl.startsWith('http')
                ? Image.network(p.imageUrl)
                : Image.asset(p.imageUrl),
          ),
        ),
        const SizedBox(height: 16),
        Text(p.name, style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        // Live average rating
        StreamBuilder<List<Review>>(
          stream: ReviewService.streamReviews(p.id),
          builder: (ctx, snap) {
            final reviews = snap.data ?? [];
            final count = reviews.length;
            final avg = count == 0
                ? 0.0
                : reviews.map((r) => r.rating).reduce((a, b) => a + b) / count;
            return Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text(avg.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text(' / 5  '),
                Text('($count reviews)', style: TextStyle(color: Colors.grey[600])),
              ],
            );
          },
        ),

        const SizedBox(height: 16),
        Text(p.description, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),

        // Size picker
        Text('Choose size', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: p.availableSizes.map((s) {
            final sel = s == _size;
            return ChoiceChip(
              label: Text(s),
              selected: sel,
              onSelected: (_) => setState(() => _size = s),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),
        // Store picker
        Text('Choose store', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: p.availableStores.map((st) {
            final sel = st == _store;
            return ChoiceChip(
              label: Text(st),
              selected: sel,
              onSelected: (_) => setState(() => _store = st),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),
        // Quantity
        Text('Quantity', style: Theme.of(context).textTheme.titleMedium),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
            ),
            Text('$_qty', style: Theme.of(context).textTheme.bodyLarge),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => setState(() => _qty++),
            ),
          ],
        ),

        const SizedBox(height: 32),
        AnimatedOpacity(
          opacity: _adding ? 0.6 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedButton(
            color: Colors.black,
            pressedColor: Colors.grey[800]!,
            onPressed: _adding ? () {} : _addToCart,
            child: _adding
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : const Text('Add to Cart', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsTab(BuildContext context) {
    final p = widget.product;

    return StreamBuilder<List<Review>>(
      stream: ReviewService.streamReviews(p.id),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final reviews = snap.data ?? [];
        final total = reviews.length;
        if (total == 0) {
          return Center(
            child: Text('No reviews yet', style: TextStyle(color: Colors.grey[600])),
          );
        }

        // compute distribution
        final counts = List<int>.filled(6, 0);
        for (final r in reviews) counts[r.rating]++;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // big average + stars
            Text(
              (reviews.map((r) => r.rating).reduce((a, b) => a + b) / total)
                  .toStringAsFixed(1),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Row(
              children: List.generate(5, (i) {
                return Icon(
                  i < (reviews.map((r) => r.rating).reduce((a, b) => a + b) ~/ total)
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                );
              }),
            ),
            const SizedBox(height: 4),
            Text('$total Ratings', style: TextStyle(color: Colors.grey[600])),

            const SizedBox(height: 16),
            // distribution bars
            for (int star = 5; star >= 1; star--) ...[
              Row(
                children: [
                  Text('$star', style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: counts[star] / total,
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${counts[star]}', style: const TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
            ],

            const Divider(height: 32),

            // header with total reviews + sort + add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$total Reviews', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(children: [
                  DropdownButton<String>(
                    value: 'Most Relevant',
                    items: const [
                      DropdownMenuItem(value: 'Most Relevant', child: Text('Most Relevant')),
                      DropdownMenuItem(value: 'Newest', child: Text('Newest')),
                    ],
                    onChanged: (_) {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.black54),
                    onPressed: () => _showReviewDialog(),
                  ),
                ]),
              ],
            ),

            // each review card
            const SizedBox(height: 8),
            for (final r in reviews) Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (i) => Icon(
                    i < r.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  )),
                ),
                title: Text(r.content),
                subtitle: Text('${r.author} • ${timeAgo(r.createdAt)}', style: TextStyle(color: Colors.grey[600])),
                trailing: PopupMenuButton<String>(
                  onSelected: (opt) {
                    if (opt == 'edit') _showReviewDialog(existing: r);
                    if (opt == 'delete') ReviewService.deleteReview(r.id);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 7) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(_tabs.index == 0 ? 'Details' : 'Reviews'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'Reviews'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildDetailsTab(context),
          _buildReviewsTab(context),
        ],
      ),
    );
  }
}
