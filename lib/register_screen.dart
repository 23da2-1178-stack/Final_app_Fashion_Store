import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';
import 'auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),

      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: const Color(0xFF1B263B),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: inputDecoration("Full Name", Icons.person),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: addressController,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              decoration: inputDecoration("Address", Icons.home),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: contactController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: inputDecoration("Contact Number", Icons.phone),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: inputDecoration("Email", Icons.email),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: inputDecoration("Password", Icons.lock),
            ),

            const SizedBox(height: 30),

            // =========================
            // REGISTER BUTTON
            // =========================
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF415A77),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 15,
                ),
              ),

              onPressed: isLoading
                  ? null
                  : () async {
                      // VALIDATION
                      if (nameController.text.trim().isEmpty ||
                          addressController.text.trim().isEmpty ||
                          contactController.text.trim().isEmpty ||
                          emailController.text.trim().isEmpty ||
                          passwordController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all fields"),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      // REGISTER USER
                      final result = await AuthService.register(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );

                      if (result == null) {
                        final user = AuthService.getCurrentUser();

                        if (user != null) {
                          // SAVE USER PROFILE IN FIREBASE
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .set({
                                'name': nameController.text.trim(),
                                'address': addressController.text.trim(),
                                'contact': contactController.text.trim(),
                                'email': emailController.text.trim(),
                              });
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Registered Successfully"),
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(result)));
                      }

                      setState(() {
                        isLoading = false;
                      });
                    },

              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Register"),
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Already have an account? Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // INPUT DESIGN
  // =========================
  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),

      prefixIcon: Icon(icon, color: Colors.lightBlueAccent),

      filled: true,
      fillColor: Colors.white10,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
