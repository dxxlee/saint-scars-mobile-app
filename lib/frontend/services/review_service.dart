// lib/frontend/services/review_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class ReviewService {
  static final _reviews = FirebaseFirestore.instance.collection('reviews');

  /// Stream all reviews for a given productId,
  /// but fetch unsorted then sort in Dart.
  static Stream<List<Review>> streamReviews(String productId) {
    return _reviews
        .where('productId', isEqualTo: productId)
        .snapshots()
        .map((snap) {
      final all = snap.docs.map((d) => Review.fromDoc(d)).toList();
      // client-side sort descending by createdAt:
      all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return all;
    });
  }

  static Future<void> addReview(Review r) {
    // serverTimestamp will be set on write
    return _reviews.add(r.toJson());
  }

  static Future<void> updateReview(Review r) {
    return _reviews.doc(r.id).update({
      'author':  r.author,
      'rating':  r.rating,
      'content': r.content,
      // keep createdAt unchanged
    });
  }

  static Future<void> deleteReview(String id) {
    return _reviews.doc(id).delete();
  }
}
