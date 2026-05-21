import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_service.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: const Color(0xFF1B263B),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: OrderService.getUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders yet"));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var doc = orders[index];
              var data = doc.data() as Map<String, dynamic>;

              return Card(
                color: const Color(0xFF1B263B),
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    "Order #${doc.id.substring(0, 8)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total: LKR ${data['total']}"),
                      Text("Status: ${data['status']}"),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: data['status'] == 'pending'
                          ? Colors.orange
                          : Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data['status'],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Items:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...(data['items'] as List).map((item) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(item['name']),
                              subtitle: Text(
                                "LKR ${item['price']} x ${item['quantity']}",
                              ),
                              trailing: Text(
                                "LKR ${item['price'] * item['quantity']}",
                              ),
                            );
                          }).toList(),
                          const Divider(),
                          Text("Delivery Address: ${data['address']}"),
                          Text("Payment: ${data['paymentMethod']}"),
                          Text(
                            "Order Date: ${_formatDate(data['orderDate'])}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "N/A";
    DateTime date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }
}
