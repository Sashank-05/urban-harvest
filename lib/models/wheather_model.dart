import 'package:geolocator/geolocator.dart';
import 'dart:convert';

class Weather{
  late final String cityName;
  late final String temperature;
  late final String mainCondition;

  Weather({
    required this.cityName,
    required this.mainCondition,
    required this.temperature,
  });

  factory Weather.fromJson(Map<String,dynamic>json){
    return Weather(cityName: json['name'],
      mainCondition:json['weather'][0]['main'] ,
      temperature: json['main']['temp'].toString(),);

  }


}