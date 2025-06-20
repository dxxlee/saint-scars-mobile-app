// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../models/post.dart';
// import '../services/api_service.dart';
// import '../constants.dart';
//
// class NewPostScreen extends StatefulWidget {
//   const NewPostScreen({super.key});
//
//   @override
//   State<NewPostScreen> createState() => _NewPostScreenState();
// }
//
// class _NewPostScreenState extends State<NewPostScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final ApiService _apiService = ApiService();
//   String _author = '';
//   String _content = '';
//   bool _isSubmitting = false;
//
//   void _submit() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       setState(() {
//         _isSubmitting = true;
//       });
//
//       // Создаем новый отзыв (Post). Здесь timestamp можно установить как 0 или текущее время.
//       final newPost = Post(
//         profileImageUrl: 'assets/images/profile1.jpg',
//         comment: _content,
//         timestamp: 0,
//       );
//
//       try {
//         final success = await _apiService.createReview(newPost);
//         if (success) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Review created successfully')),
//           );
//           context.pop(); // Закрываем экран создания отзыва
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       } finally {
//         setState(() {
//           _isSubmitting = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Create Review')),
//       body: Padding(
//         padding: const EdgeInsets.all(defaultPadding),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Your Name',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                 (value != null && value.isNotEmpty) ? null : 'Please enter your name',
//                 onSaved: (value) => _author = value ?? '',
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Your Review',
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 4,
//                 validator: (value) =>
//                 (value != null && value.length > 10) ? null : 'Review must be at least 10 characters long',
//                 onSaved: (value) => _content = value ?? '',
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
