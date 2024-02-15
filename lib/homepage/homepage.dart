import 'package:flutter/material.dart';
import 'package:urban_harvest/constant_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Some Text',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Weather box
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Weather: Sunny',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Horizontally scrollable boxes
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildHorizontalBox('Box 1'),
                        _buildHorizontalBox('Box 2'),
                        _buildHorizontalBox('Box 3'),
                        _buildHorizontalBox('Box 4'),
                        _buildHorizontalBox('Box 5'),
                        // Add more boxes as needed
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
            backgroundColor: AppColors.backgroundColor2,
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

        },
      ),
    );
  }

  Widget _buildHorizontalBox(String label) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.tertiaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
