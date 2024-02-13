import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:urban_harvest/landing/landing.dart';

import 'homepage/homepage.dart';
import 'login/login.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Login Page',
      home: CheckAuth(), // Check authentication status
    );
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    // Check if user is already signed in
    final isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const LandingPage()), // Navigate to LandingPage if logged in
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>

                LoginPage()), // Navigate to LoginPage if not logged in

      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // Show loading indicator while checking authentication
      ),
    );
  }
}
