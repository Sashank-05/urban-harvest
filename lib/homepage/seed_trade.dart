import 'dart:math' show asin, cos, pi, pow, sin, sqrt;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../constant_colors.dart';

class SeedTradeContent extends StatefulWidget {
  const SeedTradeContent({Key? key});

  @override
  State<SeedTradeContent> createState() => _SeedTradeContentState();
}

class _SeedTradeContentState extends State<SeedTradeContent> {
  final _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot>? _tradesStream;
  late User? _currentUser;
  late Position _userPosition;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _getUserLocation();
    _tradesStream = _firestore.collection('Trades').snapshots();
    print(_currentUser);
  }
  @override
  void dispose() {
    //.cancel(); // Cancel the subscription
    super.dispose();
  }

  void _getUserLocation() async {
    // Get user's current location
    _userPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      if (!mounted) return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          "Trade Seeds",
          style: TextStyle(color: AppColors.primaryColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            color: AppColors.primaryColor,
            onPressed: () {
              // Implement message functionality (navigation, etc.)
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            StreamBuilder<QuerySnapshot>(
              stream: _tradesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading trades'));
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                final trades = snapshot.data!.docs;
                final sortedTrades = _sortTradesByDistance(trades);

                return Column(
                  children: tilesFromTrades(sortedTrades),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement navigation to create trade page
        },
        child: const Icon(Icons.add),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  List<Widget> tilesFromTrades(List<QueryDocumentSnapshot> trades) {
    return trades.map((trade) {
      final city = trade.get('city');
      final imageUrl = trade.get('image');
      final itemName = trade.get('itemName');
      final location = trade.get('location');
      final tradeItems = trade.get('tradeItem') as List<dynamic>;
      final address = _convertLatLonToAddress(location); // Optional conversion

      return GestureDetector(
        onTap: () {
          // Navigate to trade details page
          _navigateToTradeDetailsPage(context, trade);
        },
        child: _buildTradeBox(
          itemName,
          tradeItems[0] as String, // Assuming first item is trade type
          tradeItems[1] as String, // Assuming second item is trade value
          imageUrl: imageUrl,
          address: address,
        ),
      );
    }).toList();
  }

  Widget _buildTradeBox(
      String seedName,
      String tradeType,
      String tradeValue, {
        String? imageUrl,
        String? address,
      }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            Image.network(
              imageUrl,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.25,
            ),
          SizedBox(
            height: 20,
          ),
          if (address != null)
            Text(
              address,
              style: const TextStyle(color: AppColors.secondaryColor),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                seedName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text("for", style: TextStyle(color: AppColors.primaryColor)),
              Column(
                children: [
                  Text(
                    tradeType,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "or",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    tradeValue,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  // Optional: Implement this function to convert GeoPoint to address
  String? _convertLatLonToAddress(GeoPoint location) {
    // TODO: Implement address conversion logic here
    // You can use geocoding services or libraries for this
    return null;
  }

  List<QueryDocumentSnapshot> _sortTradesByDistance(
      List<QueryDocumentSnapshot> trades) {
    // Sort trades by distance from user's location
    trades.sort((a, b) {
      final aLocation = a['location'] as GeoPoint;
      final bLocation = b['location'] as GeoPoint;
      final aDistance = _calculateDistance(aLocation.latitude, aLocation.longitude);
      final bDistance = _calculateDistance(bLocation.latitude, bLocation.longitude);
      return aDistance.compareTo(bDistance);
    });
    return trades;
  }

  double _calculateDistance(double lat, double lon) {
    const earthRadius = 6371.0; // in kilometers

    final userLat = _userPosition.latitude;
    final userLon = _userPosition.longitude;

    final dLat = _degreesToRadians(lat - userLat);
    final dLon = _degreesToRadians(lon - userLon);

    final a = pow(sin(dLat / 2), 2) +
        cos(_degreesToRadians(userLat)) *
            cos(_degreesToRadians(lat)) *
            pow(sin(dLon / 2), 2);
    final c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void _navigateToTradeDetailsPage(BuildContext context, QueryDocumentSnapshot trade) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TradeDetailsPage(trade: trade),
      ),
    );
  }
}

class TradeDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot trade;

  const TradeDetailsPage({Key? key, required this.trade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemName = trade['itemName'];
    final tradeItems = trade['tradeItem'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(itemName),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trade Type: ${tradeItems[0]}'),
            Text('Trade Value: ${tradeItems[1]}'),
            // Add more details here as needed
          ],
        ),
      ),
    );
  }
}
