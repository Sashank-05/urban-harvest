import 'package:flutter/material.dart';
import 'package:urban_harvest/constant_colors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLocationSharingEnabled =
      true; // Placeholder for location sharing state

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
              color: AppColors.primaryColor),
        )),
      ),
      body: Padding(
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
            const Text(
              'ExampleUsername', // Static example username
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: AppColors.primaryColor),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.backgroundColor3),
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
                            color: AppColors.primaryColor),
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
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(30),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text('Required for Trade feature and Weather.',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                            fontSize: 16)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Logic for logout
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.backgroundColor3)),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 180,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Logic for delete account
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.backgroundColor3)),
                child: const Text('Delete Account',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
