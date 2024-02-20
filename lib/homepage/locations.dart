import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../constant_colors.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();

  GoogleMapController? _mapController;
  Position? _currentPosition;
  List<Marker> _markers = [];

  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    _getCurrentLocation();
    // _fetchPosts();
  }

  _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return; // Handle this scenario
      }
    }

    _currentPosition = await Geolocator.getCurrentPosition();
  }

  _fetchLocations() async {
    final country = await getCurrentCountry();
    final city = await getCurrentCity();

    if (country.isNotEmpty && city.isNotEmpty) {
      final countryDoc =
          await _firestore.collection('Location').doc(country).get();
      if (countryDoc.exists) {
        final List<dynamic>? locations = countryDoc.data()?[city];
        if (locations != null) {
          final cityMarkers = locations.map((location) {
            GeoPoint geoPoint = location;
            return Marker(
              markerId: MarkerId('${geoPoint.latitude}-${geoPoint.longitude}'),
              // Use a unique identifier for each marker
              position: LatLng(geoPoint.latitude, geoPoint.longitude),
              infoWindow: InfoWindow(
                title: city, // Use city name as title
              ),
            );
          }).toList();
          _markers.addAll(cityMarkers);
          _updateCameraPosition();
          print(_markers);
          setState(() {});
        } else {
          print("Locations for $city is empty");
        }
      } else {
        print("Country document does not exist");
      }
    } else {
      print("Country or city is empty");
    }
  }

  _updateCameraPosition() {
    if (_markers.isNotEmpty && _mapController != null) {
      LatLngBounds bounds = _boundsFromMarkers();
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }
  LatLngBounds _boundsFromMarkers() {
    double minLat = _markers[0].position.latitude;
    double minLng = _markers[0].position.longitude;
    double maxLat = _markers[0].position.latitude;
    double maxLng = _markers[0].position.longitude;

    for (Marker marker in _markers) {
      double lat = marker.position.latitude;
      double lng = marker.position.longitude;

      minLat = min(lat, minLat);
      minLng = min(lng, minLng);
      maxLat = max(lat, maxLat);
      maxLng = max(lng, maxLng);
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
/*
  _fetchPosts() async {
    final postsSnapshot = await _firestore.collection('posts').orderBy('timestamp', descending: true).get();
    _posts = postsSnapshot.docs.map((doc) {
      return Post(
        id: doc.id,
        content: doc['content'],
        imageUrl: doc['imageUrl'],
        timestamp: doc['timestamp'].toDate(),
        comments: doc['comments'],
      );
    }).toList();
    setState(() {});
  }

  _createPost(String content, String imageUrl) async {
    final postRef = await _firestore.collection('posts').add({
      'content': content,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.now(),
      'comments': [],
    });
    await _firestore.collection('posts').doc(postRef.id).update({
      'id': postRef.id,
    });
  }

  _handleImagePick() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageRef = _storage.ref().child('images/${pickedFile.name}');
      final uploadTask = imageRef.putFile(File(pickedFile.path));
      final downloadUrl = await uploadTask.then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
      await _createPost('', downloadUrl);
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        toolbarOpacity: 0,
        title: const Text(
          "Locations",
          style: TextStyle(
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  //_currentPosition!.latitude, _currentPosition!.longitude),
                  12.91,
                  77.723),
              zoom: 12,
            ),
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
            markers: Set<Marker>.of(_markers),
          ),
          if (_markers.isEmpty) // Show loading indicator if markers are empty
            Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {}, //_handleImagePick,
              tooltip: 'Add Post',
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

class Post {
  final String id;
  final String content;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> comments;

  Post({
    required this.id,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
    required this.comments,
  });
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

Future<String> getCurrentCountry() async {
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

  String? country = placemarks[0].country;

  return country ?? "";
}
