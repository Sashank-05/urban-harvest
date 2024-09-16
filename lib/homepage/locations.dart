import 'dart:async';
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
              position: LatLng(geoPoint.latitude, geoPoint.longitude),
              infoWindow: InfoWindow(
                title: city,
              ),
            );
          }).toList();
          _markers.addAll(cityMarkers);
          _updateCameraPosition();
          setState(() {});
        }
      }
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
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: AppColors.primaryColor,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
          ? GoogleMap(
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
      )
          : ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: _posts[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostPage()),
          );
        },
        backgroundColor: AppColors.textColorLight,
        child: Icon(
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

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _showComments = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor3,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                child: Text(
                  widget.post.displayName[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.post.displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textColorDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (widget.post.imageUrl.isNotEmpty)
            Container(
              width: double.infinity, // Make the image container as wide as possible
              height: 200, // Fixed height for uniformity
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(widget.post.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 10),
          Text(
            widget.post.content,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textColorDark,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _showComments ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: AppColors.primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _showComments = !_showComments;
                  });
                },
              ),
              Text(
                '${widget.post.comments.length} Comments',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColorDark,
                ),
              ),
            ],
          ),
          if (_showComments)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.post.comments.map((comment) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      comment,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColorLight,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
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
    return "";
  }

  List<Placemark> placemarks = [];
  try {
    placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
  } catch (e) {
    print("Error getting placemarks: $e");
    return "";
  }

  if (placemarks.isEmpty) {
    print("Placemarks is empty");
    return "";
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
    return "";
  }

  List<Placemark> placemarks = [];
  try {
    placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
  } catch (e) {
    print("Error getting placemarks: $e");
    return "";
  }

  if (placemarks.isEmpty) {
    print("Placemarks is empty");
    return "";
  }

  String? country = placemarks[0].country;

  return country ?? "";
}
