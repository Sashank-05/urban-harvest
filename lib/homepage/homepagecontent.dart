import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:urban_harvest/models/random.dart';
import 'package:urban_harvest/models/wheather_model.dart';
import 'package:urban_harvest/homepage/detect.dart';

import '../services/weather_service.dart';

final weatherService _weatherService =
weatherService('18f721c26d5b14924ff362d01d237cde');
Weather? _weather;

RandomFact randomFact = RandomFact();
String ss = randomFact.did;

class HomePageContent extends StatefulWidget {
  final Weather? weather;

  const HomePageContent({Key? key, this.weather}) : super(key: key);

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late Completer<void> _fetchDataCompleter;

  @override
  void initState() {
    super.initState();
    _fetchDataCompleter = Completer<void>();
    _fetchWeather();
  }

  @override
  void dispose() {
    if (!_fetchDataCompleter.isCompleted) {
      _fetchDataCompleter.completeError('Cancelled');
    }
    super.dispose();
  }

  _fetchWeather() async {
    String cityName = await _weatherService
        .getCurrentCity(); // Ensure this method exists and works as expected
    print(cityName);
    try {
      final weather = await _weatherService.getWeather(cityName);
      if (!mounted) return;
      if (!_fetchDataCompleter.isCompleted) {
        _fetchDataCompleter.complete();
      }
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      if (!_fetchDataCompleter.isCompleted) {
        _fetchDataCompleter.completeError(e);
      }
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                //color: AppColors.tertiaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                ' Hello User !!!!',
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: AppColors.tertiaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '  Your plants  ',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Horizontally scrollable boxes
            SizedBox(
              height: 140,
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

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Weather box
                  Container(
                    height: 118,
                    width: 200,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
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
                                '${_weather?.temperature}°C',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${_weather?.mainCondition}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ]),
                        Lottie.asset(
                            getWeatherAnimation(_weather?.mainCondition),
                            height: 100,
                            width: 90),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 180,
                    child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.tertiaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      'Did you know',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Lottie.asset(
                                      'assets/img/homepage/vis/question.json',
                                      height: 30,
                                      width: 30),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  ss,
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {}),
                  ),
                  SizedBox(
                    height: 200,
                    width: 180,
                    child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.tertiaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('test disease detection'),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InferencePage()));
                        }),
                  ),
                ]),
          ],
        ),
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

String getWeatherAnimation(String? mainCondition) {
  if (mainCondition == null)
    return 'assets/img/homepage/weather_ani/sunny.json';

  switch (mainCondition.toLowerCase()) {
    case 'clouds':
      return 'assets/img/homepage/vis/sunny_clouded.json';
    case 'mist':
      return 'assets/img/homepage/vis/mist.json';
    case 'smoke':
      return 'assets/img/homepage/vis/smoke.json';
    case 'haze':
      return 'assets/img/homepage/vis/haze.json';
    case 'dust':
      return 'assets/img/homepage/vis/dusty.json';
    case 'fog':
      return 'assets/img/homepage/vis/fog.json';
    case 'rain':
      return 'assets/img/homepage/vis/rain.json';
    case 'drizzle':
      return 'assets/img/homepage/vis/sunny_drizzle.json';
    case 'shower rain':
      return 'assets/img/homepage/vis/sunny_drizzle.json';
    case 'thunderstorms':
      return 'assets/img/homepage/vis/thunderstorm.json';
    case 'clear':
      return 'assets/img/homepage/vis/sunny.json';

    default:
      return 'assets/img/homepage/vis/sunny.json';
  }
}