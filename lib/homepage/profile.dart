import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../login/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLocationSharingEnabled =
      true; // Placeholder for location sharing state
  String _displayName = ''; // Placeholder for displayName

  @override
  void initState() {
    super.initState();
    _loadDisplayName();
  }

  Future<void> _loadDisplayName() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .get();
      setState(() {
        _displayName = userData['displayName'];
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error loading displayName: $e");
      }
    }
  }

  Future<void> _logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    if(!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      await user?.delete();
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('Users').doc(user?.uid);

      // Call the delete method to delete the document
      documentReference.delete().then((value) {
        if (kDebugMode) {
          print('Document deleted successfully');
        }
      }).catchError((error) {
        if (kDebugMode) {
          print('Failed to delete document: $error');
        }
      });
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      // Handle error while deleting account
      if (kDebugMode) {
        print("Error deleting account: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Center(
          child: Text(
            'Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView to avoid overflow
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'assets/img/homepage/profile/user.png'), // Placeholder image
              ),
              const SizedBox(height: 20),
              Text(
                _displayName, // Display displayName loaded from Firestore
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: AppColors.primaryColor,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.backgroundColor3,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Share Location Data',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        Switch(
                          activeColor: AppColors.primaryColor,
                          inactiveThumbColor: AppColors.backgroundColor3,
                          value: _isLocationSharingEnabled,
                          onChanged: (value) {
                            setState(() {
                              _isLocationSharingEnabled = value;
                            });
                            // Logic for toggling location sharing
                          },
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryColor2,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(30),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        'Required for Trade feature and Locations.',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      AppColors.backgroundColor3,
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 180,
                height: 50,
                child: ElevatedButton(
                  onPressed: _deleteAccount,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      AppColors.backgroundColor3,
                    ),
                  ),
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

