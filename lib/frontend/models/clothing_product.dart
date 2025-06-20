// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ClothingProduct {
//   final String id;
//   final String name;
//   final String description;
//   final double price;
//   final double? discountedPrice;
//   final List<String> availableSizes;
//   final List<String> availableStores;
//   final String imageUrl;
//   final String category;
//
//   ClothingProduct({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     this.discountedPrice,
//     required this.availableSizes,
//     required this.availableStores,
//     required this.imageUrl,
//     required this.category,
//   });
//
//   factory ClothingProduct.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
//     final data = doc.data()!;
//     return ClothingProduct(
//       id: doc.id,
//       name: data['name'] as String? ?? '',
//       description: data['description'] as String? ?? '',
//       price: (data['price'] as num?)?.toDouble() ?? 0.0,
//       discountedPrice: (data['discountedPrice'] as num?)?.toDouble(),
//       availableSizes: List<String>.from(data['availableSizes'] ?? <String>[]),
//       availableStores: List<String>.from(data['availableStores'] ?? <String>[]),
//       imageUrl: data['imageUrl'] as String? ?? '',
//       category: data['category'] as String? ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'name': name,
//     'description': description,
//     'price': price,
//     if (discountedPrice != null) 'discountedPrice': discountedPrice,
//     'availableSizes': availableSizes,
//     'availableStores': availableStores,
//     'imageUrl': imageUrl,
//     'category': category,
//   };
// }
