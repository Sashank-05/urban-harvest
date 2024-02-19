import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:urban_harvest/login/login.dart';
import 'package:urban_harvest/models/wheather_model.dart';
import 'package:urban_harvest/homepage/detect.dart';

import '../services/weather_service.dart';

final weatherService _weatherService =
    weatherService('18f721c26d5b14924ff362d01d237cde');
Weather? _weather;
int _selectedIndex = 0;

class HomePageContent extends StatefulWidget {
  final Weather? weather;

  const HomePageContent({Key? key, this.weather}) : super(key: key);

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

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
        if (!mounted) return;
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                _auth.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text("test sign out")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InferencePage()));
              },
              child: const Text("test disease detection"))
        ],
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
