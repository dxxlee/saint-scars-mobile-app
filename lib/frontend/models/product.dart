import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountedPrice;
  final List<String> availableSizes;
  final List<String> availableStores;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountedPrice,
    required this.availableSizes,
    required this.availableStores,
    required this.imageUrl,
    required this.category,
  });

  /// Create a Product instance from Firestore document
  factory Product.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Product(
      id: doc.id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      discountedPrice: (data['discounted_price'] as num?)?.toDouble(),
      availableSizes: List<String>.from(data['available_sizes'] ?? <String>[]),
      availableStores: List<String>.from(data['available_stores'] ?? <String>[]),
      imageUrl: data['image_url'] as String? ?? '',
      category: data['category'] as String? ?? '',
    );
  }

  /// Create a Product instance from a JSON-like map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountedPrice: json['discounted_price'] != null
          ? (json['discounted_price'] as num).toDouble()
          : null,
      availableSizes: json['available_sizes'] != null
          ? List<String>.from(json['available_sizes'])
          : <String>[],
      availableStores: json['available_stores'] != null
          ? List<String>.from(json['available_stores'])
          : <String>[],
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }

  /// Convert Product to JSON-like map for saving/updating
  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    if (discountedPrice != null) 'discounted_price': discountedPrice,
    'available_sizes': availableSizes,
    'available_stores': availableStores,
    'image_url': imageUrl,
    'category': category,
  };
}
