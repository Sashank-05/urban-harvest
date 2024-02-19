import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:urban_harvest/login/login.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor2,
        iconTheme: const IconThemeData(color: AppColors.textColorDark),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 25.0),
          TextField(
            controller: _usernameController,
            style: const TextStyle(color: AppColors.textColorDark),
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: Color(0xFF40916c), width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFF40916c), width: 2)),
                labelText: 'Username',
                labelStyle: const TextStyle(
                  color: AppColors.textColorDark,
                  fontFamily: 'Montserrat',
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
            cursorColor: const Color(0xFF40916c),
          ),
          const SizedBox(height: 25.0),
          TextField(
            controller: _emailController,
            style: const TextStyle(color: AppColors.textColorDark),
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFF40916c), width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFF40916c), width: 2)),
                labelText: 'Email',
                labelStyle: const TextStyle(
                  color: AppColors.textColorDark,
                  fontFamily: 'Montserrat',
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
            cursorColor: const Color(0xFF40916c),
          ),
          const SizedBox(height: 25.0),
          TextField(
            controller: _passwordController,
            style: const TextStyle(color: AppColors.textColorDark),
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFF40916c), width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFF40916c), width: 2)),
                labelText: 'Password',
                labelStyle: const TextStyle(
                  color: AppColors.textColorDark,
                  fontFamily: 'Montserrat',
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
            cursorColor: const Color(0xFF40916c),
          ),
          const SizedBox(height: 25.0),
          ElevatedButton(
              onPressed: _signup,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiaryColor2),
              child: const Text(
                'Register',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: AppColors.textColorDark,
                ),
              )),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Already have an account?",
            style: TextStyle(
                color: AppColors.textColorDark,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.textColorDark,
                fontFamily: 'Montserrat'),
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiaryColor2,
                  fixedSize: const Size(300, 50)),
              child: const Text(
                'Login',
                style: TextStyle(
                    color: AppColors.textColorDark, fontFamily: 'Montserrat'),
              )),
        ],
      ),
    );
  }

  void _signup() async {
    //String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      if (kDebugMode) {
        print('User is successfully created');
      }
      if (!mounted) return;
      Navigator.pushNamed(context, '/login');
    } else {
      if (kDebugMode) {
        print('some error occurred');
      }
    }
  }
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      if (kDebugMode) {
        print("Some error occurred!");
      }
    }
    return null;
  }
}
