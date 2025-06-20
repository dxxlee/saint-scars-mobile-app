// import 'package:flutter/material.dart';
// import '../models/review.dart';
// import 'package:intl/intl.dart'; // добавьте в pubspec.yaml: intl: ^0.17.0
//
// class ReviewCard extends StatelessWidget {
//   final Review review;
//
//   const ReviewCard({Key? key, required this.review}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Форматируем напрямую DateTime через intl
//     final dateText = DateFormat('yyyy-MM-dd HH:mm').format(review.createdAt);
//
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: ListTile(
//         leading: CircleAvatar(
//           child: Text(
//             review.authorId.isNotEmpty
//                 ? review.authorId[0].toUpperCase()
//                 : '?',
//           ),
//         ),
//         title: Text(review.authorId),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(review.content),
//             const SizedBox(height: 6),
//             Text('Product ID: ${review.productId}',
//                 style: const TextStyle(fontSize: 12, color: Colors.grey)),
//             const SizedBox(height: 4),
//             Text('Created: $dateText',
//                 style: const TextStyle(fontSize: 12, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }
// }
