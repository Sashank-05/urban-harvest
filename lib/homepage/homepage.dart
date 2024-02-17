import 'package:flutter/material.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:urban_harvest/homepage/seed_trade.dart';
import 'package:urban_harvest/login/login.dart';
import 'package:urban_harvest/services/weather_service.dart';
import 'package:urban_harvest/models/wheather_model.dart';
import 'package:urban_harvest/homepage/detect.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final weatherService _weatherService =
      weatherService('18f721c26d5b14924ff362d01d237cde');
  Weather? _weather;

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
    final GoogleSignIn googleSignIn = GoogleSignIn();
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
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _weather?.cityName ?? "city loading",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${_weather?.temperature}c',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ]),
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
                        _buildHorizontalBox('Box 6'),

                        // Add more boxes as needed
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  googleSignIn.disconnect();

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Text("test sign out")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraClassifierPage()));
                },
                child: const Text("test disease detection"))
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
          if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SeedTradePage()));
          }
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
