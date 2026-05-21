import 'package:flutter/material.dart';
import 'auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  bool isLoading = false;

  Future<void> resetPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter your email")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await AuthService.forgotPassword(email);

    setState(() {
      isLoading = false;
    });

    if (result == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Email Sent"),
          content: const Text(
            "Password reset link has been sent to your email.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),

      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: const Color(0xFF1B263B),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 30),

            const Icon(Icons.lock_reset, size: 80, color: Colors.white),

            const SizedBox(height: 20),

            const Text(
              "Enter your email to reset password",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF415A77),
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 15,
                ),
              ),

              onPressed: isLoading ? null : resetPassword,

              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Send Reset Email"),
            ),
          ],
        ),
      ),
    );
  }
}
