import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrderService {
  static final _orders = fs.FirebaseFirestore.instance.collection('orders');

  /// Place a new order document
  /// Отправить новый заказ
  static Future<void> placeOrder({
    required List<CartItem> items,
    required String address,
    required String paymentMethod,
  }) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final total = items.fold<double>(
        0, (sum, i) => sum + i.price * i.quantity);
    // Собираем документ с полем userId
    final data = Order(
      id: '', // неважно, Firestore сам присвоит
      items: items,
      total: total,
      address: address,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
    ).toJsonWithUser(uid);

    return _orders.add(data);
  }

  /// Stream all orders (you can filter by uid inside front‐end if you want)
  /// Поток заказов *только* текущего пользователя
  static Stream<List<Order>> streamOrders() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _orders
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snap) =>
          snap.docs.map((doc) => Order.fromFirestore(doc)).toList()
      );
  }
}
