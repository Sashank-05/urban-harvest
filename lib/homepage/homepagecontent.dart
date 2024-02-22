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
import 'package:urban_harvest/landing/plant_list.dart';
import '../services/weather_service.dart';
import 'package:urban_harvest/landing/guides/aloevera-guide.dart';
import 'package:urban_harvest/landing/guides/cabbage-guide.dart';
import 'package:urban_harvest/landing/guides/cauliflower-guide.dart';
import 'package:urban_harvest/landing/guides/chilli-guide.dart';
import 'package:urban_harvest/landing/guides/coriander-guide.dart';
import 'package:urban_harvest/landing/guides/green-beans-guide.dart';
import 'package:urban_harvest/landing/guides/hibiscus-guide.dart';
import 'package:urban_harvest/landing/guides/jasmine-guide.dart';
import 'package:urban_harvest/landing/guides/marigold-guide.dart';
import 'package:urban_harvest/landing/guides/mint-guide.dart';
import 'package:urban_harvest/landing/guides/rose-guide.dart';
import 'package:urban_harvest/landing/guides/sunflower-guide.dart';
import 'package:urban_harvest/landing/guides/tomato-guide.dart';
import 'package:urban_harvest/landing/guides/tropical-leaves-guide.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

List<String> userPlants = ['Rose', 'Cauliflower', 'Cabbage'];

class WateringReminderWidget extends StatefulWidget {
  @override
  _WateringReminderWidgetState createState() => _WateringReminderWidgetState();
}

class _WateringReminderWidgetState extends State<WateringReminderWidget> {
  bool _isWatered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.backgroundColor3,
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reminder to water your plants 💧 ',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                fontSize: 18),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding:
                const EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
            decoration: BoxDecoration(
                color: AppColors.tertiaryColor2,
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Did you water your plants today?',
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.primaryColor,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    Checkbox(
                        activeColor: AppColors.backgroundColor,
                        value: _isWatered,
                        onChanged: (value) {
                          setState(() {
                            _isWatered = value!;
                          });
                        }),
                  ],
                ),
                _isWatered
                    ? const Text(
                        'Yay! Your plants are happy 🌱😄 ',
                        style: TextStyle(
                          fontSize: 17,
                          color: AppColors.primaryColor,
                          fontFamily: 'Montserrat',
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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

  Widget _buildHorizontalBox(String label, String imagePath, Widget guideName) {
    return Container(
      width: 170,
      height: 300,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.tertiaryColor2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.primaryColor,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.tertiaryColor)),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => guideName),
                          (route) => false);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'View Guide',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _showDeleteConfirmation(context, label);
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.red[400],
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildBoxes() {
    List<Widget> boxes = [];
    for (String name in userPlants) {
      boxes.add(_buildHorizontalBox(name, imageDict[name]!, guideDict[name]!));
    }
    return boxes;
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  //color: AppColors.tertiaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Hello UserName',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                    color: AppColors.backgroundColor3,
                    borderRadius: BorderRadius.circular(30)),
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Your plants 🌱 ',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primaryColor,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: buildBoxes(),
                      ),
                    ),
                  ],
                ),
              ),
              WateringReminderWidget(),
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
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String label) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor3,
          title: const Text(
            'Delete Plant',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: AppColors.primaryColor),
          ),
          content: Text(
            'Are you sure you want to delete $label from your list?',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: AppColors.primaryColor),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Container(
                  width: 70,
                  decoration: BoxDecoration(
                      color: AppColors.tertiaryColor2,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(10),
                  child: const Center(
                      child: Text(
                    'No',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: AppColors.primaryColor),
                  ))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Container(
                  width: 70,
                  decoration: BoxDecoration(
                      color: AppColors.tertiaryColor2,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(10),
                  child: const Center(
                      child: Text(
                    'Yes',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: AppColors.primaryColor),
                  ))),
            ),
          ],
        );
      },
    );
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
}
