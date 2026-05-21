import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    final CollectionReference users = FirebaseFirestore.instance.collection(
      'users',
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF1B263B),
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: users.doc(userId).snapshots(),

        builder: (context, snapshot) {
          // LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ERROR
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          // NO DATA
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "No Profile Data Found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(15),

            child: Column(
              children: [
                const SizedBox(height: 20),

                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF415A77),

                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),

                const SizedBox(height: 10),

                Text(
                  data['name'] ?? 'No Name',

                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(15),

                  decoration: BoxDecoration(
                    color: const Color(0xFF1B263B),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Column(
                    children: [
                      ProfileItem(Icons.person, "Name", data['name'] ?? ''),

                      const Divider(color: Colors.grey),

                      ProfileItem(Icons.home, "Address", data['address'] ?? ''),

                      const Divider(color: Colors.grey),

                      ProfileItem(
                        Icons.phone,
                        "Contact",
                        data['contact'] ?? '',
                      ),

                      const Divider(color: Colors.grey),

                      ProfileItem(Icons.email, "Email", data['email'] ?? ''),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD1D8E0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 12,
                    ),
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },

                  child: const Text("Edit Profile"),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70,
                      vertical: 12,
                    ),
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },

                  child: const Text("Change Password"),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 90,
                      vertical: 12,
                    ),
                  ),

                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },

                  child: const Text("Logout"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// =======================
// PROFILE ITEM WIDGET
// =======================
class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileItem(this.icon, this.title, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(icon, color: Colors.lightBlueAccent),

          const SizedBox(width: 10),

          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
