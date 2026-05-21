import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // =========================
  // LOAD USER DATA
  // =========================
  Future<void> loadUserData() async {
    final user = auth.currentUser;

    if (user != null) {
      final doc = await firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        setState(() {
          nameController.text = data['name'] ?? '';
          addressController.text = data['address'] ?? '';
          contactController.text = data['contact'] ?? '';
        });
      }
    }
  }

  // =========================
  // SAVE DATA
  // =========================
  Future<void> updateProfile() async {
    final user = auth.currentUser;

    if (user == null) return;

    setState(() {
      isLoading = true;
    });

    await firestore.collection('users').doc(user.uid).update({
      'name': nameController.text.trim(),
      'address': addressController.text.trim(),
      'contact': contactController.text.trim(),
    });

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated Successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),

      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF1B263B),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),

              decoration: const InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: addressController,
              style: const TextStyle(color: Colors.white),

              decoration: const InputDecoration(
                labelText: "Address",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: contactController,
              style: const TextStyle(color: Colors.white),

              decoration: const InputDecoration(
                labelText: "Contact",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF415A77),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 15,
                ),
              ),

              onPressed: isLoading ? null : updateProfile,

              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
