import 'dart:math' show asin, cos, pi, pow, sin, sqrt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../constant_colors.dart';
import 'add_trade.dart';

class SeedTradeContent extends StatefulWidget {
  const SeedTradeContent({super.key});

  @override
  State<SeedTradeContent> createState() => _SeedTradeContentState();
}

class _SeedTradeContentState extends State<SeedTradeContent> {
  final _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot>? _tradesStream;
  late User? _currentUser;
  Position? _userPosition;// Assuming Position() is a valid default constructor


  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _getUserLocation();
    _tradesStream = _firestore.collection('Trades').snapshots();
  }

  @override
  void dispose() {
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
        title: const Text(
          "Trade",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontFamily: 'Montserrat',
          ),
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
            const SizedBox(height: 30),
            StreamBuilder<QuerySnapshot>(
              stream: _tradesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading trades'));
                }

                if (!snapshot.hasData) {
                  return const Center(
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTradePage()),
          );
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
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
      final address = _convertLatLonToAddress(location);
      final sellerUID = trade.get("uid");

      return Padding(
        // Add Padding widget here
        padding: const EdgeInsets.symmetric(vertical: 8),
        // Adjust the vertical spacing as needed
        child: GestureDetector(
          onTap: () {
            // Navigate to trade details page
            _navigateToTradeDetailsPage(context, trade);
          },
          child: _buildTradeBox(
              itemName,
              tradeItems[0] as String, // Assuming first item is trade type
              tradeItems[1] as String, // Assuming second item is trade value
              imageUrl: imageUrl,
              uid: sellerUID),
        ),
      );
    }).toList();
  }

  Widget _buildTradeBox(String seedName, String tradeType, String tradeValue,
      {String? imageUrl, String? address, String? uid}) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('Users').doc(uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        try {
          if (uid == null || uid.isEmpty) {
            throw Exception('UID is null or empty');
          }
          if (!snapshot.data!.exists) {
            return const Text('User not found',style: TextStyle(color:AppColors.primaryColor),);
          }
          final trader = snapshot.data!.get("displayName") ?? 'Unknown';

          return SizedBox(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor2,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Trade posted by $trader"),
                  if (imageUrl != null)
                    Image.network(
                      imageUrl,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                  const SizedBox(
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
                      const Text("for",
                          style: TextStyle(color: AppColors.primaryColor)),
                      Column(
                        children: [
                          Text(
                            tradeType,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            "or",
                            style: TextStyle(
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
            ),
          );
        } catch (e) {
          print('Error fetching user data: $e');
          return const Text('Unknown');
        }
      },
    );
  }

  String? _convertLatLonToAddress(GeoPoint location) {
    // TODO: Implement address conversion logic here
    return null;
  }

  List<QueryDocumentSnapshot> _sortTradesByDistance(
      List<QueryDocumentSnapshot> trades) {
    // Sort trades by distance from user's location
    trades.sort((a, b) {
      final aLocation = a['location'] as GeoPoint;
      final bLocation = b['location'] as GeoPoint;
      final aDistance =
          _calculateDistance(aLocation.latitude, aLocation.longitude);
      final bDistance =
          _calculateDistance(bLocation.latitude, bLocation.longitude);
      return aDistance.compareTo(bDistance);
    });
    return trades;
  }

  double _calculateDistance(double lat, double lon) {
    const earthRadius = 6371.0; // in kilometers

    final userLat = _userPosition?.latitude ?? 0;
    final userLon = _userPosition?.longitude ?? 0;

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

  void _navigateToTradeDetailsPage(
      BuildContext context, QueryDocumentSnapshot trade) {
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
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          itemName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Card(
          color: AppColors.backgroundColor2, // Set inner background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    trade.get('image'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.primaryColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'You give',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textColorLight,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${tradeItems[0]} or ${tradeItems[1]}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textColorLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.primaryColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'You get',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textColorLight,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            itemName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textColorLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: AppColors.backgroundColor3,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Have Queries?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColorDark,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Chat with the seller',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textColorDark,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          print("hello");
                        },
                        icon: const Icon(
                          CommunityMaterialIcons.message_bulleted,
                          size: 30,
                          color: Colors.black,
                        ),
                        label: const Text('Chat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
