import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_model.dart';

class CartService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==============================
  // GET USER CART COLLECTION
  // ==============================
  static CollectionReference<Map<String, dynamic>> _getCartCollection() {
    String? userId = _auth.currentUser?.uid;

    if (userId == null) {
      throw Exception("User not logged in");
    }

    return _firestore.collection('users').doc(userId).collection('cart');
  }

  // ==============================
  // ADD TO CART
  // ==============================
  static Future<String?> addToCart(CartItemModel item) async {
    try {
      QuerySnapshot<Map<String, dynamic>> existing = await _getCartCollection()
          .where('name', isEqualTo: item.name)
          .where('price', isEqualTo: item.price)
          .get();

      // If item already exists
      if (existing.docs.isNotEmpty) {
        String docId = existing.docs.first.id;

        int currentQty = existing.docs.first.data()['quantity'] ?? 1;

        await _getCartCollection().doc(docId).update({
          'quantity': currentQty + item.quantity,
        });
      } else {
        // Add new item
        await _getCartCollection().add(item.toMap());
      }

      return null;
    } catch (e) {
      return "Failed to add to cart: $e";
    }
  }

  // ==============================
  // GET CART ITEMS
  // ==============================
  static Stream<List<CartItemModel>> getCartItems() {
    return _getCartCollection().snapshots().map((snapshot) {
      cartItems.clear();

      List<CartItemModel> items = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();

        CartItemModel item = CartItemModel(
          id: doc.id,
          name: data['name'] ?? '',
          price: data['price'] ?? 0,
          quantity: data['quantity'] ?? 1,
        );

        items.add(item);
        cartItems.add(item);
      }

      return items;
    });
  }

  // ==============================
  // TOTAL PRICE
  // ==============================
  static Future<int> getTotalPrice() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _getCartCollection()
          .get();

      int total = 0;

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();

        int price = data['price'] ?? 0;
        int quantity = data['quantity'] ?? 1;

        total += price * quantity;
      }

      return total;
    } catch (e) {
      print("Error getting total: $e");
      return 0;
    }
  }

  // ==============================
  // UPDATE QUANTITY
  // ==============================
  static Future<String?> updateQuantity(String itemId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        await removeFromCart(itemId);
      } else {
        await _getCartCollection().doc(itemId).update({
          'quantity': newQuantity,
        });
      }

      return null;
    } catch (e) {
      return "Failed to update quantity: $e";
    }
  }

  // ==============================
  // REMOVE ITEM
  // ==============================
  static Future<String?> removeFromCart(String itemId) async {
    try {
      await _getCartCollection().doc(itemId).delete();

      return null;
    } catch (e) {
      return "Failed to remove item: $e";
    }
  }

  // ==============================
  // CLEAR CART
  // ==============================
  static Future<String?> clearCart() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _getCartCollection()
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      return null;
    } catch (e) {
      return "Failed to clear cart: $e";
    }
  }
}
