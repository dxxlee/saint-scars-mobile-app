// // lib/frontend/screens/new_review_screen.dart
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../services/review_service.dart';
//
// class NewReviewScreen extends StatefulWidget {
//   /// You must pass the product's Firestore ID when navigating here.
//   final String productId;
//
//   const NewReviewScreen({
//     Key? key,
//     required this.productId,
//   }) : super(key: key);
//
//   @override
//   State<NewReviewScreen> createState() => _NewReviewScreenState();
// }
//
// class _NewReviewScreenState extends State<NewReviewScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String _content = '';
//   bool _isSubmitting = false;
//
//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();
//
//     setState(() => _isSubmitting = true);
//     try {
//       final user = FirebaseAuth.instance.currentUser!;
//       await ReviewService.addReview(
//         productId: widget.productId,
//         authorId: user.uid,
//         authorName: user.displayName ?? user.email ?? 'Anonymous',
//         content: _content,
//       );
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Review submitted!')));
//       Navigator.of(context).pop();
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error: $e')));
//     } finally {
//       setState(() => _isSubmitting = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Write a Review')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Your review',
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 5,
//                 validator: (v) =>
//                 v == null || v.trim().length < 5 ? 'Minimum 5 chars' : null,
//                 onSaved: (v) => _content = v!.trim(),
//               ),
//               const SizedBox(height: 16),
//               _isSubmitting
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                 onPressed: _submit,
//                 child: const Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
