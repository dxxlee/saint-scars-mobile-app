// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/clothing_product.dart';
// import '../models/review.dart';
// import '../models/auth_response.dart';
// import '../models/app_user.dart';
//
// class ApiService {
//   // базовый URL
//   final String baseUrl = 'http://10.0.2.2:8000/api';
//   static String? authToken;
//
//   /// Сохраняем токен после login/register
//   void updateToken(String token) => authToken = token;
//
//   /// Заголовки с авторизацией
//   Map<String, String> get _authHeaders {
//     return {
//       'Content-Type': 'application/json',
//       if (authToken != null) 'Authorization': 'Token $authToken',
//     };
//   }
//
//   /// Login (POST /api/login/)
//   Future<AuthResponse> login(String email, String password) async {
//     final resp = await http.post(
//       Uri.parse('$baseUrl/login/'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email, 'password': password}),
//     );
//     if (resp.statusCode != 200) {
//       throw Exception('Login failed: ${resp.body}');
//     }
//     final authResp = AuthResponse.fromJson(jsonDecode(resp.body));
//     updateToken(authResp.token);
//     return authResp;
//   }
//
//   /// Register (POST /api/register/)
//   Future<AuthResponse> register(String username, String email, String password) async {
//     final resp = await http.post(
//       Uri.parse('$baseUrl/register/'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'username': username,
//         'email': email,
//         'password': password,
//       }),
//     );
//     if (resp.statusCode != 201) {
//       throw Exception('Register failed: ${resp.body}');
//     }
//     final authResp = AuthResponse.fromJson(jsonDecode(resp.body));
//     updateToken(authResp.token);
//     return authResp;
//   }
//
//   /// Получение профиля (GET /api/profile/)
//   Future<AppUser> getProfile() async {
//     if (authToken == null) {
//       throw Exception('Not authenticated');
//     }
//     final resp = await http.get(
//       Uri.parse('$baseUrl/profile/'),
//       headers: _authHeaders,
//     );
//     if (resp.statusCode != 200) {
//       throw Exception('Failed to load profile: ${resp.statusCode}');
//     }
//     return AppUser.fromJson(json.decode(resp.body) as Map<String, dynamic>);
//   }
//
//   /// Загрузка списка товаров (GET /api/products/)
//   Future<List<ClothingProduct>> getProducts() async {
//     final resp = await http.get(Uri.parse('$baseUrl/products/'));
//     if (resp.statusCode != 200) {
//       throw Exception('Failed to load products: ${resp.statusCode}');
//     }
//     final List data = json.decode(resp.body);
//     return data.map((j) => ClothingProduct.fromJson(j as Map<String, dynamic>)).toList();
//   }
//
//   /// Загрузка отзывов (GET /api/reviews/)
//   Future<List<Review>> getReviews() async {
//     final resp = await http.get(Uri.parse('$baseUrl/reviews/'));
//     if (resp.statusCode != 200) {
//       throw Exception('Failed to load reviews: ${resp.statusCode}');
//     }
//     final List data = json.decode(resp.body);
//     return data.map((j) => Review.fromJson(j as Map<String, dynamic>)).toList();
//   }
//
//   /// Создание нового отзыва (POST /api/reviews/)
//   Future<bool> createReview(Review review) async {
//     final resp = await http.post(
//       Uri.parse('$baseUrl/reviews/'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(review.toJson()),
//     );
//     if (resp.statusCode != 201) {
//       throw Exception('Failed to create review: ${resp.body}');
//     }
//     return true;
//   }
// }
