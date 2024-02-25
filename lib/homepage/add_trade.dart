import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constant_colors.dart';

class AddTradePage extends StatefulWidget {
  const AddTradePage({Key? key}) : super(key: key);

  @override
  State<AddTradePage> createState() => _AddTradePageState();
}

class _AddTradePageState extends State<AddTradePage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _tradeOtherController = TextEditingController();
  final TextEditingController _tradeValueController = TextEditingController();

  File? _image;

  final picker = ImagePicker();

  Future<String?> uploadImageToFirebase() async {
    if (_image == null) return null;

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = firebase_storage.FirebaseStorage.instance
          .ref('trade_images')
          .child('$fileName.jpg');
      final uploadTask = ref.putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Set scaffold background color
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor, // Use AppColors in app bar
        title: const Text(
          'Add New Trade',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryColor), // Set icon color
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_image != null)
                Image.file(
                  _image!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ElevatedButton(
                onPressed: () async {
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                  );

                  setState(() {
                    if (pickedFile != null) {
                      _image = File(pickedFile.path);
                    } else {
                      print('No image selected.');
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text('Take Picture'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  setState(() {
                    if (pickedFile != null) {
                      _image = File(pickedFile.path);
                    } else {
                      print('No image selected.');
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text('Choose from Gallery'),
              ),

              TextField(
                style: const TextStyle(color: AppColors.textColorDark),
                controller: _itemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  labelStyle: TextStyle(color: AppColors.textColorDark),
                ),
              ),
              TextField(
                style: const TextStyle(color: AppColors.textColorDark),
                controller: _tradeOtherController,
                decoration: const InputDecoration(
                  labelText: 'Trading for',
                  labelStyle: TextStyle(color: AppColors.textColorDark),
                ),
              ),
              TextField(
                style: const TextStyle(color: AppColors.textColorDark),
                controller: _tradeValueController,
                decoration: const InputDecoration(
                  labelText: 'Trade Value',
                  labelStyle: TextStyle(color: AppColors.textColorDark),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final imageUrl = await uploadImageToFirebase();
        
                  // Get user email
                  final user =
                      FirebaseAuth.instance.currentUser;
        
                  // Get current position
                  Position? currentPosition;
                  try {
                    currentPosition = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high,
                    );
                  } catch (e) {
                    print("Error getting current position: $e");
                  }
        
                  // Construct trade data
                  final Map<String, dynamic> tradeData = {
                    'city': await getCurrentCity(currentPosition),
                    'image': imageUrl ?? 'https://picsum.photos/300/100',
                    'itemName': _itemNameController.text,
                    'location': GeoPoint(
                      currentPosition?.latitude ?? 0.0,
                      currentPosition?.longitude ?? 0.0,
                    ),
                    'sellerEmail': user?.email,
                    'sellerUid' : user?.uid,
                    'tradeItem': [
                      _tradeValueController.text,
                      _tradeOtherController.text,
                    ],
                  };
        
                  // Add trade to Firestore
                  await FirebaseFirestore.instance
                      .collection('Trades')
                      .doc()
                      .set(tradeData);
                  // Navigate back
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text('Add Trade'),
              ),
            ],
          ),
        ),
      ),
    );

  }
}

Future<String> getCurrentCity(Position? position) async {
  if (position == null) return ""; // Return empty string if position is null

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
