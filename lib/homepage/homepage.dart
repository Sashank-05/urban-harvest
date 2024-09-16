import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:urban_harvest/homepage/homepagecontent.dart';
import 'package:urban_harvest/homepage/locations.dart';
import 'package:urban_harvest/homepage/seed_trade.dart';
import 'package:urban_harvest/homepage/profile.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(),
    const SeedTradeContent(),
    const LocationPage(),
    const ProfilePage()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        toolbarOpacity: 0,
        title:Text(
          "Urban Harvest",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.backgroundColor2,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_florist),
            label: 'Trade',
            backgroundColor: AppColors.backgroundColor2,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.pin_drop),
            label: 'Locations',
            backgroundColor: AppColors.backgroundColor2,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle_outlined),
            label: 'Profile',
            backgroundColor: AppColors.backgroundColor2,
          ),
        ],
        selectedItemColor: AppColors.primaryColor,
        backgroundColor: AppColors.tertiaryColor,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          if (!mounted) {
            return;
          } else {

           // dispose();

          }
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

}


