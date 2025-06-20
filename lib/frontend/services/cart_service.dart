// lib/services/cart_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';

class CartService {
  static final _db = FirebaseFirestore.instance;

  /// Ссылка на корневой документ корзины текущего пользователя
  static DocumentReference<Map<String, dynamic>> get _cartDoc {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _db.collection('carts').doc(uid);
  }

  /// Ссылка на подколлекцию items
  static CollectionReference<Map<String, dynamic>> get _itemsCol =>
      _cartDoc.collection('items');

  /// Стримим только эту корзину
  static Stream<List<CartItem>> streamCart() {
    return _itemsCol.snapshots().map((snap) {
      return snap.docs.map((doc) {
        // создаём CartItem из JSON в doc.data()
        return CartItem.fromJson({
          ...doc.data(),
          'productId': doc.id,      // ключевой ID товара у нас в документе
        });
      }).toList();
    });
  }

  /// Добавляем или перезаписываем пункт корзины
  static Future<void> addToCart(CartItem item) async {
    // Убедимся, что в корне документа есть userId
    await _cartDoc.set({'userId': FirebaseAuth.instance.currentUser!.uid},
        SetOptions(merge: true));
    // Теперь сам товар
    return _itemsCol.doc(item.productId).set(item.toJson());
  }

  /// Меняем только количество
  static Future<void> updateQuantity(String productId, int quantity) {
    return _itemsCol.doc(productId).update({'quantity': quantity});
  }

  /// Меняем только размер
  static Future<void> updateSize(String productId, String size) {
    return _itemsCol.doc(productId).update({'size': size});
  }

  /// Меняем только магазин
  static Future<void> updateStore(String productId, String store) {
    return _itemsCol.doc(productId).update({'store': store});
  }

  /// Удалить один пункт
  static Future<void> remove(String productId) {
    return _itemsCol.doc(productId).delete();
  }

  /// Полностью очистить корзину
  static Future<void> clear() async {
    final batch = _db.batch();
    final snaps = await _itemsCol.get();
    for (var doc in snaps.docs) batch.delete(doc.reference);
    return batch.commit();
  }
}
