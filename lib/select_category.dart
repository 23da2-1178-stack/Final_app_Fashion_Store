import 'package:flutter/material.dart';
import 'product_listing_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  final List<String> categories = const ['Men', 'Women', 'Kids', 'Accessories'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: categories.length,

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),

          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProductListingScreen(category: categories[index]),
                  ),
                );
              },

              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B), // dark blue theme
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Center(
                  child: Text(
                    categories[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
