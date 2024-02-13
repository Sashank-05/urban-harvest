import 'package:flutter/material.dart';
import 'package:urban_harvest/constant_colors.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        toolbarOpacity: 0,
        title: const Text(
          "Urban Harvest",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(

              padding: EdgeInsets.all(20),

              child: Column(
                children: [
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Some Text',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'Some more text...',
                style: TextStyle(fontSize: 18),
              ),
            ),
            // Add more text or widgets as needed below
            SizedBox(height: 100), // Placeholder for more content
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.backgroundColor2,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist),
            label: 'Trade Seeds',
            backgroundColor: AppColors.backgroundColor2,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop),
            label: 'Locations',
            backgroundColor:AppColors.backgroundColor2,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
            backgroundColor: AppColors.backgroundColor2,
          ),
        ],
        selectedItemColor: AppColors.primaryColor,
        backgroundColor: AppColors.tertiaryColor,
        onTap: (int index) {
          // Handle item tap
        },
      ),
    );
  }
}
