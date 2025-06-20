// lib/frontend/models/review.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String productId;
  final String author;
  final int rating;       // 1..5
  final String content;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.productId,
    required this.author,
    required this.rating,
    required this.content,
    required this.createdAt,
  });

  factory Review.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Review(
      id: doc.id,
      productId: data['productId'] as String,
      author:    data['author']    as String,
      rating:    (data['rating']   as num).toInt(),
      content:   data['content']   as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'author':    author,
    'rating':    rating,
    'content':   content,
    'createdAt': FieldValue.serverTimestamp(),
  };
}
