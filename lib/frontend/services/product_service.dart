import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  static final _db = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> get _productsCol =>
      _db.collection('products');

  /// Реальное-время — стрим всех продуктов
  static Stream<List<Product>> streamProducts() {
    return _productsCol.snapshots().map((snap) => snap.docs.map((doc) {
      final data = doc.data();
      return Product.fromJson({
        'id'          : doc.id,
        'name'        : data['name'],
        'description' : data['description'],
        'price'       : data['price'],
        'discounted_price': data['discounted_price'],
        'available_sizes'  : data['available_sizes']  ?? <String>[],
        'available_stores' : data['available_stores'] ?? <String>[],
        'image_url'   : data['image_url'],
        'category'    : data['category'],
      });
    }).toList());
  }

  /// Одноразово получить все
  static Future<List<Product>> getAll() async {
    final snap = await _productsCol.get();
    return snap.docs.map((doc) {
      final data = doc.data();
      return Product.fromJson({
        'id'             : doc.id,
        'name'           : data['name'],
        'description'    : data['description'],
        'price'          : data['price'],
        'discounted_price': data['discounted_price'],
        'image_url'      : data['image_url'],
        'category'       : data['category'],
        'available_sizes'  : data['available_sizes']  ?? <String>[],
        'available_stores' : data['available_stores'] ?? <String>[],
      });
    }).toList();
  }

  /// По одному ID
  static Future<Product> getById(String id) async {
    final doc = await _productsCol.doc(id).get();
    return Product.fromJson({
      'id'             : doc.id,
      ...doc.data()!,
    });
  }
}
