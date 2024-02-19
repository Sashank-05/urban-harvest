import 'dart:io';

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
    _fetchLocations();
  }

  _fetchLocations() async {
    final country = await getCurrentCountry();
    final city = await getCurrentCity();

    if (country.isNotEmpty && city.isNotEmpty) {
      final locationsSnapshot = await _firestore
          .collection('Location')
          .doc(country)
          .collection(city)
          .get();
      _markers = locationsSnapshot.docs.map((doc) {
        final List<dynamic> locations = doc['Location'];
        return locations.map((location) {
          GeoPoint geoPoint = location;
          return Marker(
            markerId: MarkerId(doc.id), // You can use a unique identifier for each marker
            position: LatLng(geoPoint.latitude, geoPoint.longitude),
          );
        }).toList();
      }).expand((element) => element).toList(); // Flatten the list of lists
      setState(() {});
    } else {
      print("Country or city is empty");
    }
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
              target: _currentPosition != null
                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                  : LatLng(0, 0),
              zoom: 12,
            ),
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
            markers: Set<Marker>.of(_markers),
          ),
         // Positioned(
         //   bottom: 16.0,
           // right: 16.0,
           // child: FloatingActionButton(
             // onPressed: _handleImagePick,
             // tooltip: 'Add Post',
             // child: Icon(Icons.add),
            //),
          //),
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
