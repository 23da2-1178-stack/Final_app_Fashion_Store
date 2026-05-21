import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();

  final newPasswordController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;

  // =========================
  // CHANGE PASSWORD
  // =========================
  Future<void> changePassword() async {
    final user = auth.currentUser;

    if (user == null) return;

    String newPassword = newPasswordController.text.trim();

    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter new password")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await user.updatePassword(newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully")),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Error")));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),

      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: const Color(0xFF1B263B),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),

              decoration: const InputDecoration(
                labelText: "Old Password (not required)",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: newPasswordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),

              decoration: const InputDecoration(
                labelText: "New Password",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF415A77),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 15,
                ),
              ),

              onPressed: isLoading ? null : changePassword,

              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Update Password"),
            ),
          ],
        ),
      ),
    );
  }
}
