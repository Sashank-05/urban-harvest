import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'homepage/homepage.dart';
import 'login/login.dart';
import 'login/login_1.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loading Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CheckAuth(), // Check authentication status
    );
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({Key? key}) : super(key: key);

  @override
  State<CheckAuth> createState() => _CheckAuthState(); // Changed to public
}

class _CheckAuthState extends State<CheckAuth> {
  // Changed to public
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    // Check if user is already signed in

    final isSignedIn = await _googleSignIn.isSignedIn();
    if (!mounted) return;

    if (isSignedIn) {
      Navigator.pushReplacement(
        context,

        MaterialPageRoute(builder: (context) => const HomePage()),

      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
