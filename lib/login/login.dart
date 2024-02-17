import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:urban_harvest/firebase_options.dart';
import 'package:urban_harvest/login/login_1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:urban_harvest/login/profile.dart';


void main() {WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Login Page',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
            fontFamily: 'Montserrat'),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor2,
      ),
      body: const SingleChildScrollView(child: LoginForm()),
    );
  }
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Sign In',
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign In'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final User? user = await _signInWithGoogle();
            if (user != null) {
              // Navigate to another screen after successful sign-in
              print('Signed in as: ${user.displayName}');
            } else {
              print('Sign in failed');
            }
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

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
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextField(
            style: const TextStyle(color: AppColors.textColorDark),
            controller: _emailController,
            decoration: InputDecoration(
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: const BorderSide(color: Color(0xFF40916c), width: 2)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: const BorderSide(color: Color(0xFF40916c), width: 2)),
                labelText: 'Email',
                labelStyle: const TextStyle(
                  color: AppColors.textColorDark,
                  fontFamily: 'Montserrat',
                ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20)),
            cursorColor: const Color(0xFF40916c),
          ),
          const SizedBox(height: 16.0),
          TextField(
            style: const TextStyle(color: AppColors.textColorDark),
            controller: _passwordController,
            decoration: InputDecoration(
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: const BorderSide(color: Color(0xFF40916c), width: 2)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: const BorderSide(color: Color(0xFF40916c), width: 2)),
                labelText: 'Password',
                labelStyle: const TextStyle(
                  color: AppColors.textColorDark,
                  fontFamily: 'Montserrat',
                ),

              contentPadding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15)),

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
                      fontFamily: 'Montserrat'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          ElevatedButton(
              onPressed: () {
                _signInWithEmailAndPassword();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiaryColor2,
                  fixedSize: const Size(300, 50)),
              child: const Text(
                'Sign in',
                style: TextStyle(
                    color: AppColors.textColorDark, fontFamily: 'Montserrat'),
              )),
          const SizedBox(height: 10,),
          const Text('OR',style: TextStyle(fontFamily: 'Montserrat',color: AppColors.textColorDark),),


          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _handleSignIn,
            icon: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: ImageIcon(AssetImage("assets/img/search.png"),

                  size: 20, color: AppColors.tertiaryColor2),

            ),
            label: const Text(
              'Login with Google',
              style: TextStyle(fontFamily: 'Montserrat', color: Color(0xFF081C15)),
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, fixedSize: const Size(300, 50)),
          ),
          const SizedBox(height: 30,),
          const Text("Don't have an account?",style: TextStyle(color:AppColors.textColorDark,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.textColorDark,fontFamily: 'Montserrat'),),
          const SizedBox(height: 5,),

          ElevatedButton(onPressed: (){Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => const ProfilePage()), (route)=>false,
          );},
              style: ElevatedButton.styleFrom(

              backgroundColor: AppColors.tertiaryColor2,
              fixedSize: const Size(300, 50)), child: const Text('Sign Up', style: TextStyle(
              color: AppColors.textColorDark, fontFamily: 'Montserrat'),) ),



        ],
      ),
    );
  }

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(_signInWithEmailAndPassword() as Widget);
  }
  Future<void> _signInWithEmailAndPassword() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }

    }
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage1()),
        );
      }
    });

  }


  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // Use GoogleSignInAccount to authenticate with your backend server
      if (googleUser != null) {
        if (!mounted) return;

        print('Logged in as: ${googleUser.email}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage1()),
        );
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }
}
