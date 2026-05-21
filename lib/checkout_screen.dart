import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cart_model.dart';
import 'cart_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController addressController = TextEditingController();

  String paymentMethod = "Cash on Delivery";

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  // ==========================
  // TOTAL
  // ==========================
  int getTotal() {
    int total = 0;

    for (var item in cartItems) {
      total += item.price * item.quantity;
    }

    return total;
  }

  // ==========================
  // PLACE ORDER
  // ==========================
  Future<void> placeOrder() async {
    try {
      String? userId = auth.currentUser?.uid;

      if (userId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User not logged in")));
        return;
      }

      // SAVE ORDER TO FIREBASE
      await firestore.collection('orders').add({
        'userId': userId,
        'orderDate': DateTime.now(),
        'address': addressController.text,
        'paymentMethod': paymentMethod,
        'total': getTotal(),

        // PRODUCTS
        'items': cartItems.map((item) {
          return {
            'id': item.id,
            'name': item.name,
            'price': item.price,
            'quantity': item.quantity,
          };
        }).toList(),
      });

      // CLEAR FIREBASE CART
      await CartService.clearCart();

      // CLEAR LOCAL CART
      cartItems.clear();

      // SUCCESS MESSAGE
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),

          content: const Text(
            "Order placed successfully!",
            style: TextStyle(color: Colors.white),
          ),

          actions: [
            TextButton(
              onPressed: () {
                cartItems.clear();
                Navigator.pop(context);
                Navigator.pop(context);
              },

              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to place order: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),

      body: Padding(
        padding: const EdgeInsets.all(15),

        child: ListView(
          children: [
            // ==========================
            // ORDER SUMMARY
            // ==========================
            const Text(
              "Order Summary",

              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...cartItems.map(
              (item) => ListTile(
                title: Text(item.name),

                subtitle: Text("Qty: ${item.quantity}"),

                trailing: Text("LKR ${item.price * item.quantity}"),
              ),
            ),

            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  "Total",

                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                Text(
                  "LKR ${getTotal()}",

                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ==========================
            // ADDRESS
            // ==========================
            const Text(
              "Delivery Address",

              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: addressController,
              maxLines: 3,

              decoration: InputDecoration(
                hintText: "Enter your address",

                filled: true,
                fillColor: Colors.white10,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==========================
            // PAYMENT METHOD
            // ==========================
            const Text(
              "Payment Method",

              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            RadioListTile(
              title: const Text("Cash on Delivery"),

              value: "Cash on Delivery",

              groupValue: paymentMethod,

              onChanged: (value) {
                setState(() {
                  paymentMethod = value!;
                });
              },
            ),

            RadioListTile(
              title: const Text("Card Payment"),

              value: "Card Payment",

              groupValue: paymentMethod,

              onChanged: (value) {
                setState(() {
                  paymentMethod = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // ==========================
            // PLACE ORDER BUTTON
            // ==========================
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF415A77),

                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 15,
                ),
              ),

              onPressed: () async {
                if (addressController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter address")),
                  );

                  return;
                }

                await placeOrder();
              },

              child: const Text("Place Order"),
            ),
          ],
        ),
      ),
    );
  }
}
