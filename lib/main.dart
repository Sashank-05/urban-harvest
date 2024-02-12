import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:urban_harvest/login/login.dart';
import 'package:urban_harvest/landing/landing.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      home: CheckAuth(), // Check authentication status
    );
  }
}

class CheckAuth extends StatefulWidget {
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
                LandingPage()), // Navigate to LandingPage if logged in
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LandingPage()), // Navigate to LoginPage if not logged in
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // Show loading indicator while checking authentication
      ),
    );
  }
}
