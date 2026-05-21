import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all products
  static Stream<QuerySnapshot> getAllProducts() {
    return _firestore.collection('products').snapshots();
  }

  // Get products by category
  static Stream<QuerySnapshot> getProductsByCategory(String category) {
    return _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots();
  }

  // Get single product by ID
  static Future<DocumentSnapshot> getProductById(String productId) {
    return _firestore.collection('products').doc(productId).get();
  }

  // Search products
  static Stream<QuerySnapshot> searchProducts(String searchTerm) {
    if (searchTerm.isEmpty) {
      return getAllProducts();
    }
    return _firestore
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: searchTerm)
        .where('name', isLessThan: searchTerm + 'z')
        .snapshots();
  }

  // Get products by price range
  static Stream<QuerySnapshot> getProductsByPriceRange(
    int minPrice,
    int maxPrice,
  ) {
    return _firestore
        .collection('products')
        .where('price', isGreaterThanOrEqualTo: minPrice)
        .where('price', isLessThanOrEqualTo: maxPrice)
        .snapshots();
  }
}
