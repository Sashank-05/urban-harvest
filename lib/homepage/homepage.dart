import 'package:flutter/material.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:urban_harvest/homepage/homepagecontent.dart';
import 'package:urban_harvest/homepage/seed_trade.dart';

import 'package:urban_harvest/services/weather_service.dart';
import 'package:urban_harvest/models/wheather_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final weatherService _weatherService =
      weatherService('18f721c26d5b14924ff362d01d237cde');
  Weather? _weather;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(),
    SeedTradeContent(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  _fetchWeather() async {
    String cityName = await _weatherService
        .getCurrentCity(); // Ensure this method exists and works as expected
    print(cityName);
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

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
      body: _pages[_selectedIndex],
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
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
