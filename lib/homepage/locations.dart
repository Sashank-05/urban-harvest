import 'dart:async';
import 'dart:ffi';
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
import 'add_post.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();

  GoogleMapController? _mapController;
  Position? _currentPosition;
  final List<Marker> _markers = [];

  List<Post> _posts = [];
  bool _showMap = false; // Variable to control map visibility

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchPosts();
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
    if (_currentPosition != null) {
      _fetchLocations();
    }
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

  _fetchPosts() async {
    final postsSnapshot = await _firestore
        .collection('Posts')
        .orderBy('timestamp', descending: true)
        .get();

    _posts = await Future.wait(postsSnapshot.docs.map((doc) async {
      final posterUid = doc['posterUid'] as String;
      final posterDoc =
          await _firestore.collection('Users').doc(posterUid).get();
      final posterName =
          posterDoc.exists ? posterDoc.get('displayName') as String : 'Unknown';

      return Post(
        id: doc.id,
        content: doc['content'],
        imageUrl: doc['imageUrl'],
        timestamp: doc['timestamp'].toDate(),
        comments: List<String>.from(doc['comments']),
        uid: posterUid,
        displayName: posterName,
      );
    }).toList());

    print(_posts);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor2,
        title: Text(
          _showMap ? "Map (${_markers.length} markers)" : "Locations",
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: AppColors.primaryColor, // Use color constant
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        // Change icon color
        actions: [
          IconButton(
            icon: const Icon(
              Icons.map_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showMap = !_showMap;
              });
            },
          ),
        ],
      ),
      body: _showMap
          ? Stack(
              children: [
                if (_markers.isNotEmpty)
                  GoogleMap(
                    initialCameraPosition: _currentPosition != null
                        ? CameraPosition(
                            target: LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                            zoom: 12,
                          )
                        : const CameraPosition(
                            target: LatLng(0, 0),
                            zoom: 1,
                          ),
                    onMapCreated: (controller) {
                      setState(() {
                        _mapController = controller;
                      });
                    },
                    markers: Set<Marker>.of(_markers),
                  ),
              ],
            )
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor3,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Posted by ${_posts[index].displayName}"),
                      if (_posts[index].imageUrl.isNotEmpty)
                        Image.network(_posts[index].imageUrl),
                      const SizedBox(height: 10),
                      // Content
                      Text(
                        _posts[index].content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textColorDark, // Use color constant
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Comments
                      Text(
                        "Comments: ${_posts[index].comments.length}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColorLight, // Use color constant
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostPage()),
          );
        },
        child: const Icon(
          Icons.add,
          color: AppColors.backgroundColor2,
        ),
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
  final String uid;
  final String displayName;

  Post({
    required this.id,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
    required this.comments,
    required this.uid,
    required this.displayName,
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
