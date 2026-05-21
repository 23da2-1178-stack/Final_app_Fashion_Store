// home_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Search Controller
  TextEditingController searchController = TextEditingController();

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fashion Store")),

      body: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          children: [
            // SEARCH BAR
            TextField(
              controller: searchController,

              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },

              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(
                hintText: "Search fashion...",

                prefixIcon: const Icon(Icons.search),

                filled: true,
                fillColor: Colors.white10,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            //  BANNER
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              height: 250,

              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 227, 226, 231),

                borderRadius: BorderRadius.circular(20),
              ),

              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Best Collection\nFor You",

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,

                            color: Color.fromARGB(255, 8, 1, 109),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Discover the best fashion collection",

                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "Start Shopping",

                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,

                            color: Color.fromARGB(255, 8, 1, 109),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),

                      child: Image.network(
                        "https://critterkids.co.in/cdn/shop/files/Untitleddesign_6_1_c2ce926b-ff6d-4bdb-bff9-03d6a1cec3a5.webp?v=1770638499&width=713",

                        width: 110,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // FIREBASE PRODUCTS
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),

                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No Products Found"));
                  }

                  var products = snapshot.data!.docs;

                  // SEARCH FILTER
                  var filteredProducts = products.where((product) {
                    var data = product.data() as Map<String, dynamic>;

                    String productName = data['name'].toString().toLowerCase();

                    return productName.contains(searchText);
                  }).toList();

                  return GridView.builder(
                    itemCount: filteredProducts.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                        ),

                    itemBuilder: (context, index) {
                      var product = filteredProducts[index];

                      return ProductCard(
                        id: product.id,

                        name: product['name'],

                        price: product['price'],

                        imageUrl: product['imageUrl'],

                        stock: product['stock'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  PRODUCT CARD
class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final dynamic price;
  final String imageUrl;
  final dynamic stock;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1B263B),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      margin: const EdgeInsets.all(8),

      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),

              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),

          Text(
            name,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),

          Text(
            "LKR $price",

            style: const TextStyle(color: Colors.lightBlueAccent),
          ),

          Text(
            "Stock: $stock",

            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF415A77),

              foregroundColor: Colors.white,
            ),

            onPressed: () async {
              cartItems.add(CartItemModel(name: name, price: price, id: ''));

              // SAVE ORDER TO FIREBASE
              await FirebaseFirestore.instance.collection('orders').add({
                'items_ID': id,
                'orderDate': DateTime.now(),

                'total': price,
                'userId': 'USER_001',
              });

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("$name added to cart")));
            },

            child: const Text("Add to Cart"),
          ),
        ],
      ),
    );
  }
}
