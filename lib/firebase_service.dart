import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<void> addUser() async {
    await users.doc("user1").set({
      'name': 'John Doe',
      'address': 'Colombo, Sri Lanka',
      'contact': '+94 77 1234567',
      'email': 'john@email.com',
    });
  }
}
