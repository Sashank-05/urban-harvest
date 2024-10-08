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
import 'package:urban_harvest/homepage/locations.dart';
import 'package:urban_harvest/landing/plant_list.dart';
import 'package:http/http.dart' as http;
import '../firebase_options.dart';
import '../login/login.dart';
import 'package:urban_harvest/landing/selectable_landing.dart';

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
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          color: AppColors.backgroundColor3,
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'Reminder to water your plants 💧 ',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  fontSize: 18),
            ),
          ),
          Container(
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
                    Expanded(
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
                    ? Text(
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
  final user = FirebaseAuth.instance.currentUser;
  late Completer<void> _fetchDataCompleter;
  List<String> userPlants = [];
  final firestore = FirebaseFirestore.instance;

  String? username;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _updateLocation();
    _fetchDataCompleter = Completer<void>();
    _fetchWeather();
    _fetchPlants();
  }

  _updateLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // Extract country name from the placemarks
    String? countryName = placemarks.first.country;
    addCurrentLocationToFirestore(countryName!, await getCurrentCity(),
        position.latitude, position.longitude);
    if (kDebugMode) {
      print("Trying to update");
    }
  }

  _fetchUsername() async {
    final user = this.user;
    final userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .get();
    setState(() {
      username = userData['displayName'];
    });
  }

  _fetchPlants() async {
    final user = this.user;
    if (user != null) {
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
                  style: TextStyle(
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
                            WidgetStateProperty.all(AppColors.tertiaryColor)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => guideName),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
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
    if (userPlants.isEmpty) {
      boxes.add(Center(
        child: Text(
          'You haven\'t added any plants \nyet!',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              fontFamily: 'Montserrat'),
        ),
      ));
      return boxes;
    }
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreeting(),
                const SizedBox(height: 16),
                _buildWeatherReport(),
                const SizedBox(height: 16),
                const WateringReminderWidget(),
                const SizedBox(height: 16),
                _buildPlantDiseaseDetector(),
                const SizedBox(height: 16),
                _buildUserPlants(),
                const SizedBox(height: 16),
                _buildRandomFact(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Text(
      'Hello ${username ?? "Plant Lover"}!',
      style: GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textColorLight,
      ),
    );
  }

  Widget _buildWeatherReport() {
    return Card(
      color: AppColors.backgroundColor3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather Report 🌦️',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tertiaryColor2,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _weather?.cityName ?? "Loading",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primaryColor,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Text(
                        '${_weather?.temperature ?? "0"}°C',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primaryColor,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Text(
                        _weather?.mainCondition ?? " ",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primaryColor,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Text(
                        '${_weather?.dayLight ?? "0 hours"} of daylight',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primaryColor,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                  Lottie.asset(
                    getWeatherAnimation(_weather?.mainCondition),
                    height: 100,
                    width: 90,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantDiseaseDetector() {
    return Card(
      color: AppColors.backgroundColor3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plant Health Check 🔍',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tertiaryColor2,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/img/homepage/disease.png',
                        height: 80,
                        width: 80,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Detect plant diseases before it\'s too late!',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primaryColor,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tertiaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InferencePage(),
                        ),
                      );
                    },
                    child: Text(
                      'Detect Disease',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.primaryColor,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserPlants() {
    return Card(
      color: AppColors.backgroundColor3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Garden 🌱',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: buildBoxes(),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectableLandingPage(),
                    ),
                  );
                },
                child: Text(
                  'Add Plants!',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.primaryColor,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRandomFact() {
    return Card(
      color: AppColors.backgroundColor3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Did You Know? 🤔',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tertiaryColor2,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                ss,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryColor,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _fetchDataCompleter = Completer<void>();
      _fetchWeather();
      _fetchPlants();
    });
    return _fetchDataCompleter.future;
  }

  void _showDeleteConfirmation(BuildContext context, String label) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor3,
          title: Text(
            'Delete Plant',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: AppColors.primaryColor),
          ),
          content: Text(
            'Are you sure you want to delete $label from your list?',
            style: TextStyle(
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
                  child: Center(
                      child: Text(
                    'No',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: AppColors.primaryColor),
                  ))),
            ),
            TextButton(
              onPressed: () async {
                String userId = FirebaseAuth.instance.currentUser!.uid;
                DocumentReference userDocRef =
                    FirebaseFirestore.instance.collection('Users').doc(userId);

                DocumentSnapshot doc = await userDocRef.get();
                if (doc.exists) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  if (data.containsKey('plants')) {
                    // Get the current list of selected plants
                    List<String> selectedPlants =
                        List<String>.from(data['plants']);

                    // Remove the deselected plant from the list
                    selectedPlants.remove(label);

                    // Update the list of selected plants in the user's document
                    await userDocRef.set(
                        {'plants': selectedPlants}, SetOptions(merge: true));
                    if (!mounted) return;
                    setState(() {
                      _fetchPlants();
                    });
                    if (!mounted) return;
                    Navigator.of(context).pop(true);
                  }
                }
              },
              child: Container(
                  width: 70,
                  decoration: BoxDecoration(
                      color: AppColors.tertiaryColor2,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(10),
                  child: Center(
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
  late final String dayLight;

  Weather(
      {required this.cityName,
      required this.mainCondition,
      required this.temperature,
      required this.dayLight});

  factory Weather.fromJson(Map<String, dynamic> json) {
    var sunrise =
        DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000)
            .toString();
    var sunset =
        DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000)
            .toString();
    final sunriseDateTime = DateTime.parse(sunrise);
    final sunsetDateTime = DateTime.parse(sunset);
    final daylightDuration = sunsetDateTime.difference(sunriseDateTime);
    final daylightHoursDouble = daylightDuration.inHours.toDouble();
    //final daylightMinutesDouble = daylightDuration.inMinutes.toDouble();
    // final remainingMinutes = daylightMinutesDouble - (daylightHoursDouble * 60);
    final daylightHours = '$daylightHoursDouble hours';
    var daylight = daylightHours.toString();

    return Weather(
        cityName: json['name'],
        mainCondition: json['weather'][0]['main'],
        temperature: json['main']['temp'].toString(),
        dayLight: daylight);
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
          // if (now.hour < 22) {
          await _showNotification();
          // }
        }
      }
    }
  }
}

Future<void> _showNotification() async {
  if (kDebugMode) {
    print("Notification called");
  }
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
    'Did you water your plants?',
    'Water them now!',
    platformChannelSpecifics,
    payload: 'test Payload',
  );
}

Future<void> onSelectNotification(String? payload) async {
  runApp(const LoginApp());
}

void addCurrentLocationToFirestore(String countryName, String cityName,
    double latitude, double longitude) async {
  DocumentReference countryDocRef =
      FirebaseFirestore.instance.collection('Location').doc(countryName);

  DocumentSnapshot countrySnapshot = await countryDocRef.get();

  if (countrySnapshot.exists) {
    Map<String, dynamic>? data =
        countrySnapshot.data() as Map<String, dynamic>?;

    if (data != null) {
      List<dynamic>? cityLocations = data[cityName] as List<dynamic>?;

      if (cityLocations != null) {
        // Check if the location already exists
        bool locationExists = cityLocations.any((location) {
          double existingLat = (location as GeoPoint).latitude;
          double existingLon = (location).longitude;
          return _areCoordinatesEqual(latitude, existingLat) &&
              _areCoordinatesEqual(longitude, existingLon);
        });

        if (locationExists) {
          if (kDebugMode) {
            print("Location already exists in the city.");
          }
          return;
        }

        // Add new location to the array
        GeoPoint newLocation = GeoPoint(latitude, longitude);
        cityLocations.add(newLocation);
        await countryDocRef.update({cityName: cityLocations});
        if (kDebugMode) {
          print("Location added successfully.");
        }
      } else {
        if (kDebugMode) {
          print("City does not exist.");
        }
      }
    } else {
      if (kDebugMode) {
        print("Country data is null.");
      }
    }
  } else {
    if (kDebugMode) {
      print("Country document does not exist.");
    }
  }
}

bool _areCoordinatesEqual(double coord1, double coord2,
    {double tolerance = 0.0001}) {
  return (coord1 - coord2).abs() < tolerance;
}
