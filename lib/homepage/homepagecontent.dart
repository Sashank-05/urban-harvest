import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:urban_harvest/homepage/detect.dart';
import 'package:urban_harvest/landing/plant_list.dart';
import 'package:http/http.dart' as http;
import '../firebase_options.dart';
import '../login/login.dart';

class WateringReminderWidget extends StatefulWidget {
  const WateringReminderWidget({Key? key}) : super(key: key);

  @override
  State<WateringReminderWidget> createState() => _WateringReminderWidgetState();
}

class _WateringReminderWidgetState extends State<WateringReminderWidget> {
  bool _isWatered = false;

  @override
  void initState() {
    super.initState();
    _checkIfWateredToday();
  }

  Future<void> _checkIfWateredToday() async {
    // Get current date
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    final firestore = FirebaseFirestore.instance;

    // Fetch the document from Firestore
    DocumentSnapshot snapshot = await firestore
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      if (userData.containsKey('dates') && userData['dates'] is List) {
        List<dynamic> dates = userData['dates'];
        bool isTodayInList =
            dates.any((date) => DateTime.parse(date).isAtSameMomentAs(today));
        setState(() {
          _isWatered = isTodayInList;
        });
      }
    }
  }

  Future<void> _updateWateringStatus(bool value) async {
    // Get current date
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch the document from Firestore
      DocumentSnapshot snapshot =
          await firestore.collection('Users').doc(user.uid).get();
      if (snapshot.exists) {
        List<dynamic> dates = [];

        // Ensure that the data is correctly casted to a Map
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

        // Check if 'dates' field exists and is a list
        if (userData.containsKey('dates') && userData['dates'] is List) {
          dates = List.from(userData['dates']);
        } else {
          firestore
              .collection('Users')
              .doc(user.uid)
              .set({"dates": []}, SetOptions(merge: true));
        }

        // Toggle today's date in the list
        if (value) {
          if (!dates.contains(today.toIso8601String())) {
            dates.add(today.toIso8601String());
          }
        } else {
          dates.remove(today.toIso8601String());
        }

        // Update the document in Firestore
        await firestore.collection('Users').doc(user.uid).update({
          'dates': dates,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
            margin: const EdgeInsets.only(top: 10, ),
            padding:
            const EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
            decoration: BoxDecoration(
                color: AppColors.tertiaryColor2,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Did you water your plants today?',
                        style: TextStyle(
                          fontSize: 17,
                          color: AppColors.primaryColor,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    Checkbox(
                        activeColor: AppColors.backgroundColor,
                        value: _isWatered,
                        onChanged: (value) {
                          setState(() {
                            _isWatered = value!;
                            _updateWateringStatus(value);
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

final WeatherService _weatherService =
    WeatherService('18f721c26d5b14924ff362d01d237cde');
Weather? _weather;

RandomFact randomFact = RandomFact();
String ss = randomFact.did;

class HomePageContent extends StatefulWidget {
  final Weather? weather;

  const HomePageContent({Key? key, this.weather}) : super(key: key);

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late Completer<void> _fetchDataCompleter;
  List<String> userPlants = [];

  @override
  void initState() {
    super.initState();
    _fetchDataCompleter = Completer<void>();
    _fetchWeather();
    _fetchPlants();
  }

  _fetchPlants() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      DocumentSnapshot snapshot =
          await firestore.collection('Users').doc(user.uid).get();
      if (snapshot.exists) {
        Map<String, dynamic>? userData =
            snapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('plants')) {
          setState(() {
            userPlants = List<String>.from(userData['plants']);
          });
        }
      }
    }
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => guideName),
                      );
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
    if (kDebugMode) {
      print(cityName);
    }
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
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              const WateringReminderWidget(),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Disease Detection',style: TextStyle(fontFamily: 'Montserrat',fontSize: 14),),
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
    if (mainCondition == null) {
      return 'assets/img/homepage/vis/sunny.json';
    }
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

class RandomFact {
  List<String> mess = [
    'Bamboo is the fastest-growing woody plant in the world. It can grow up to 35 inches in a single day.',
    'Tomato juice is the official state beverage of Ohio, honoring the part A. W. Livingston of Reynoldsburg, Ohio, played in popularizing the tomato in the late 1800s.',
    'Vanilla flavoring comes from the pod of an orchid, Vanilla planifolia. Though the pods are called vanilla beans, they are not actually in the legume family like green beans.',
    'Saffron, used as a flavoring in Mediterranean cooking, is harvested from the stigmas of a type of fall-blooming crocus, Crocus sativus.',
    'The first potatoes were cultivated in Peru about 7,000 years ago.',
    'The average strawberry has 200 seeds. It is the only fruit that bears its seeds on the outside.',
    'There are over 300,000 identified plant species and the list is growing all the time!',
    'Oak trees don’t produce acorns until they are 50 years old!'
  ];

  late String did;

  RandomFact() {
    shuffleMess();
  }

  String shuffleMess() {
    mess.shuffle();
    did = mess.first;
    return (did);
  }
}

class Weather {
  late final String cityName;
  late final String temperature;
  late final String mainCondition;

  Weather({
    required this.cityName,
    required this.mainCondition,
    required this.temperature,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      mainCondition: json['weather'][0]['main'],
      temperature: json['main']['temp'].toString(),
    );
  }
}

class WeatherService {
  static const baseUrl = 'http://api.openweathermap.org/data/2.5/weather';
  late final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error getting current position: $e");
      }
      return ""; // Return empty string if unable to get position
    }

    List<Placemark> placemarks = [];
    try {
      placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error getting placemarks: $e");
      }
      return ""; // Return empty string if unable to get placemarks
    }

    if (placemarks.isEmpty) {
      if (kDebugMode) {
        print("Placemarks is empty");
      }
      return ""; // Return empty string if placemarks is empty
    }

    String? city = placemarks[0].locality;

    return city ?? "";
  }
}

Future<void> checkDatabase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);

  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    DocumentSnapshot snapshot =
        await firestore.collection('Users').doc(user.uid).get();
    if (snapshot.exists) {
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;
      if (userData != null && userData['dates'] is List) {
        List<dynamic> dates = userData['dates'];
        if (!dates
            .any((date) => DateTime.parse(date).isAtSameMomentAs(today))) {
          if (now.hour < 22) {
            await _showNotification();
          }
        }
      }
    }
  }
}

Future<void> _showNotification() async {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'abc12i3',
    'Urban Harvest',
    icon: "@mipmap/ic_launcher",
    importance: Importance.max,
    priority: Priority.high,
  );
  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.show(
    0,
    'Notification Title',
    'Notification Body',
    platformChannelSpecifics,
    payload: 'New Payload',
  );
}

Future<void> onSelectNotification(String? payload) async {
  runApp(const LoginApp());
}
