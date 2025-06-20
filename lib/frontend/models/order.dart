// lib/models/order.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final String address;
  final String paymentMethod;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.address,
    required this.paymentMethod,
    required this.createdAt,
  });

  /// Фабрика для DocumentSnapshot
  factory Order.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Order(
      id: doc.id,
      items: (data['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (data['total'] as num).toDouble(),
      address: data['address'] as String,
      paymentMethod: data['paymentMethod'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Для записи в Firestore с привязкой к пользователю
  Map<String, dynamic> toJsonWithUser(String uid) => {
    'userId'        : uid,
    'items'         : items.map((e) => e.toJson()).toList(),
    'total'         : total,
    'address'       : address,
    'paymentMethod' : paymentMethod,
    'createdAt'     : FieldValue.serverTimestamp(),
  };
}
