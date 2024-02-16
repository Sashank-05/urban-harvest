import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/wheather_model.dart';
import 'package:http/http.dart' as http;

class weatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  late final String apiKey;

  weatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));
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
      print("Error getting current position: $e");
      return ""; // Return empty string if unable to get position
    }

    print(position);

    List<Placemark> placemarks = [];
    try {
      placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      print("Error getting placemarks: $e");
      return ""; // Return empty string if unable to get placemarks
    }

    if (placemarks.isEmpty) {
      print("Placemarks is empty");
      return ""; // Return empty string if placemarks is empty
    }

    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
