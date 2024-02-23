import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:urban_harvest/login/login.dart';
import 'package:urban_harvest/login/login_1.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  bool checked = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor2,
          iconTheme: const IconThemeData(color: AppColors.textColorDark),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 25.0),
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: AppColors.textColorDark),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFF40916c),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFF40916c),
                      width: 2,
                    ),
                  ),
                  labelText: 'Username',
                  labelStyle: const TextStyle(
                    color: AppColors.textColorDark,
                    fontFamily: 'Montserrat',
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
                cursorColor: const Color(0xFF40916c),
              ),
              const SizedBox(height: 25.0),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: AppColors.textColorDark),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFF40916c),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFF40916c),
                      width: 2,
                    ),
                  ),
                  labelText: 'Email',
                  labelStyle: const TextStyle(
                    color: AppColors.textColorDark,
                    fontFamily: 'Montserrat',
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
                cursorColor: const Color(0xFF40916c),
              ),
              const SizedBox(height: 25.0),
              TextField(
                controller: _passwordController,
                obscureText: !_showPassword,
                style: const TextStyle(color: AppColors.textColorDark),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFF40916c),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFF40916c),
                      width: 2,
                    ),
                  ),
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    color: AppColors.textColorDark,
                    fontFamily: 'Montserrat',
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF40916c),
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                cursorColor: const Color(0xFF40916c),
              ),
              const SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiaryColor2,
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: AppColors.textColorDark,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Already have an account?",
                style: TextStyle(
                  color: AppColors.textColorDark,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.textColorDark,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiaryColor2,
                  fixedSize: const Size(300, 50),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: AppColors.textColorDark,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signup() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    try {
      UserCredential userCredential = await _auth.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.uid)
            .set({'displayName': username}, SetOptions(merge: true));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage1()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create user. Please try again later.'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Failed to create user. ';
      if (e.code == 'weak-password') {
        errorMessage += 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage += 'The account already exists for that email.';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
