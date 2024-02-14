import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:urban_harvest/login/login_1.dart';
void main() {
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
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Sign in'),
        titleTextStyle: TextStyle(color: AppColors.textColorDark, fontSize: 20),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor2,

      ),
      body: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
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
          TextField(
            style: TextStyle(color: AppColors.textColorDark),
            controller: _emailController,
            decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: AppColors.textColorDark)
            ),

          ),
          const SizedBox(height: 16.0),
          TextField(
            style: const TextStyle(color: AppColors.textColorDark),
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
                labelStyle: TextStyle(color: AppColors.textColorDark)
            ),
            obscureText: true,
          ),
          const SizedBox(height: 200,),
          ElevatedButton.icon(
            onPressed: _handleSignIn,

            icon: ImageIcon(AssetImage("assets/img/search.png"),size:20,color:AppColors.tertiaryColor2),
           label:Text('Login with Google'),
            style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,fixedSize:Size(300,50 )
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // Use GoogleSignInAccount to authenticate with your backend server
      if (googleUser != null) {
        print('Logged in as: ${googleUser.email}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage_1()),
        );
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }
}
