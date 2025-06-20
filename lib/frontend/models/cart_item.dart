// lib/models/cart_item.dart

class CartItem {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final String size;
  final String store;

  CartItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.size,
    required this.store,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'imageUrl': imageUrl,
    'price': price,
    'quantity': quantity,
    'size': size,
    'store': store,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json['productId'] as String,
    name: json['name'] as String,
    imageUrl: json['imageUrl'] as String,
    price: (json['price'] as num).toDouble(),
    quantity: json['quantity'] as int,
    size: json['size'] as String,
    store: json['store'] as String,
  );
}
