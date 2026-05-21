import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_model.dart';

class OrderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Place new order
  static Future<String?> placeOrder({
    required String address,
    required String paymentMethod,
    required List<CartItemModel> items,
    required int total,
  }) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        userId = "user1";
      }

      // Create order document
      await _firestore.collection('orders').add({
        'userId': userId,
        'address': address,
        'paymentMethod': paymentMethod,
        'items': items
            .map(
              (item) => {
                'name': item.name,
                'price': item.price,
                'quantity': item.quantity,
              },
            )
            .toList(),
        'total': total,
        'status': 'pending',
        'orderDate': FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      return "Failed to place order: $e";
    }
  }

  // Get user orders
  static Stream<QuerySnapshot> getUserOrders() {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      // For demo, use "user1" if no auth user
      userId = "user1";
    }

    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .snapshots();
  }

  // Update order status
  static Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status,
    });
  }

  // Get order by ID
  static Future<DocumentSnapshot> getOrderById(String orderId) {
    return _firestore.collection('orders').doc(orderId).get();
  }
}
