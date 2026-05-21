class CartItemModel {
  final String id;
  final String name;
  final int price;
  int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  // Convert object to Firebase Map
  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price, 'quantity': quantity};
  }

  // Convert Firebase data to object
  factory CartItemModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CartItemModel(
      id: documentId,
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
      quantity: map['quantity'] ?? 1,
    );
  }
}

List<CartItemModel> cartItems = [];
