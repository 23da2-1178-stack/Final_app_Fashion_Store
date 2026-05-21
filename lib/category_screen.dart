import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'cart_model.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: widget.category)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Products Found"));
          }

          var products = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(10),

            itemCount: products.length,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),

            itemBuilder: (context, index) {
              var doc = products[index];

              return Card(
                color: const Color(0xFF1B263B),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                margin: const EdgeInsets.all(8),

                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),

                        child: Image.network(
                          doc['imageUrl'] ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      doc['name'] ?? '',

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,

                        color: Colors.white,
                      ),
                    ),

                    Text(
                      "LKR ${doc['price']}",

                      style: const TextStyle(color: Colors.lightBlueAccent),
                    ),

                    const SizedBox(height: 5),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF415A77),
                      ),

                      onPressed: () async {
                        //  SAVE TO FIREBASE CART
                        await FirebaseFirestore.instance
                            .collection('cart')
                            .add({
                              'id': doc.id,
                              'name': doc['name'],
                              'price': doc['price'],
                              'quantity': 1,
                            });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${doc['name']} added to cart"),
                          ),
                        );
                      },

                      child: const Text("Add to Cart"),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
