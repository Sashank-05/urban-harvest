import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:urban_harvest/firebase_options.dart';
import 'package:urban_harvest/homepage/homepage.dart';
import 'package:urban_harvest/login/login_1.dart';
import 'package:urban_harvest/login/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Login Page',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Sign in'),
        titleTextStyle: const TextStyle(
          color: AppColors.textColorDark,
          fontSize: 20,
          fontFamily: 'Montserrat',
        ),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor2,
      ),
      body: const SingleChildScrollView(child: LoginForm()),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 50),
            child: Image.asset(
              'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png',
              width: 100,
              height: 100,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 40.0),
            child: Text(
              'Urban Harvest',
              style: TextStyle(
                color: AppColors.textColorDark,
                fontFamily: 'Montserrat',
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextField(
            style: const TextStyle(color: AppColors.textColorDark),
            controller: _emailController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(21),
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
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            ),
            cursorColor: const Color(0xFF40916c),
          ),
          const SizedBox(height: 16.0),
          TextField(
            style: const TextStyle(color: AppColors.textColorDark),
            controller: _passwordController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(21),
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
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            ),
            cursorColor: const Color(0xFF40916c),
            obscureText: true,
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.textColorDark,
                    color: AppColors.textColorDark,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: _signInWithEmailAndPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tertiaryColor2,
              fixedSize: const Size(300, 50),
            ),
            child: const Text(
              'Sign in',
              style: TextStyle(
                color: AppColors.textColorDark,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'OR',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: AppColors.textColorDark,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _handleSignIn,
            icon: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: ImageIcon(
                AssetImage("assets/img/search.png"),
                size: 20,
                color: AppColors.tertiaryColor2,
              ),
            ),
            label: const Text(
              'Login with Google',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Color(0xFF081C15),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              fixedSize: const Size(300, 50),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Don't have an account?",
            style: TextStyle(
              color: AppColors.textColorDark,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.textColorDark,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignUpPage()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tertiaryColor2,
              fixedSize: const Size(300, 50),
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: AppColors.textColorDark,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('No user found for that email.');
        }
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
      }
    }
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (kDebugMode) {
          print('User is currently signed out!');
        }
      } else {
        if (kDebugMode) {
          print('User is signed in!');
        }
        if (!mounted) return;
        String userId = FirebaseAuth.instance.currentUser!.uid;
        DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(userId);

        userDocRef.get().then((doc) {
          if (doc.exists) {
            Map<String, dynamic> data =
            doc.data() as Map<String, dynamic>;
            if (!data.containsKey('plants')) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage1()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }
          }
        });
      }
    });
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set(
          {'displayName': googleUser.displayName}, SetOptions(merge: true));

      if (kDebugMode) {
        print('Logged in as: ${googleUser.email}');
      }

      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('Users').doc(userId);

      userDocRef.get().then((doc) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (!data.containsKey('plants')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage1()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error signing in with Google: $error');
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
