import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBDqN6IeTcTsz0tzSyBMd7rkS_UjW_QIY0",
        authDomain: "fashion-store-95698.firebaseapp.com",
        projectId: "fashion-store-95698",
        storageBucket: "fashion-store-95698.firebasestorage.app",
        messagingSenderId: "550550325852",
        appId: "1:550550325852:web:db74e8aadabe4af2d63499",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fashion Store',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF0D1B2A),
        scaffoldBackgroundColor: const Color(0xFF0D1B2A),

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1B263B),
          secondary: Color(0xFF415A77),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B263B),
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
