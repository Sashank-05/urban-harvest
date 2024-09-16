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
  Position? _userPosition; // Assuming Position() is a valid default constructor

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
        title: Text(
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTradePage()),
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

  List<Widget> tilesFromTrades(List<QueryDocumentSnapshot> trades) {
    return trades.map((trade) {
      final city = trade.get('city');
      final imageUrl = trade.get('image');
      final itemName = trade.get('itemName');
      final location = trade.get('location');
      final tradeItems = trade.get('tradeItem') as List<dynamic>;
      final address = _convertLatLonToAddress(location);

      final sellerUID = trade.get("sellerUid") ?? trade.get("uid") ?? '';

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: GestureDetector(
          onTap: () {
            _navigateToTradeDetailsPage(context, trade);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: AppColors.backgroundColor2, // Match with TradeDetailsPage
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Trader Information
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(sellerUID)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (!snapshot.data!.exists) {
                            return const Text('User not found');
                          }
                          final trader =
                              snapshot.data!.get("displayName") ?? 'Unknown';
                          return Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(trader[0],
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Posted by $trader',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors
                                      .textColorDark, // Match with TradeDetailsPage
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        itemName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors
                              .textColorLight, // Match with TradeDetailsPage
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${tradeItems[0]} or ${tradeItems[1]}',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors
                              .textColorLight, // Match with TradeDetailsPage
                        ),
                      ),
                      if (address != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          address,
                          style: TextStyle(
                            color: AppColors
                                .textColorDark, // Match with TradeDetailsPage
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: AppColors
                                  .primaryColor, // Match with TradeDetailsPage
                            ),
                            onPressed: () {
                              // Handle like
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.comment,
                              color: AppColors
                                  .primaryColor, // Match with TradeDetailsPage
                            ),
                            onPressed: () {
                              // Handle comments
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
            return Text(
              'User not found',
              style: TextStyle(color: AppColors.primaryColor),
            );
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
                      style: TextStyle(color: AppColors.secondaryColor),
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
                      Text("for",
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
        backgroundColor: AppColors.backgroundColor2, // App bar background color
        title: Text(
          itemName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textColorLight, // Title color
          ),
        ),
        iconTheme: IconThemeData(
            color: AppColors.textColorLight), // App bar icon color
      ),
      backgroundColor: AppColors.backgroundColor3, // Page background color
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: AppColors.backgroundColor2,
              // Background color for image container
              child: ClipRRect(
                child: Image.network(
                  trade.get('image'),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300, // Height for the image
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor2,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.backgroundColor3,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'You give',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors
                                        .textColorLight, // Text color updated
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${tradeItems[0]} or ${tradeItems[1]}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors
                                        .textColorLight, // Text color updated
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
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.backgroundColor3,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'You get',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors
                                        .textColorLight, // Text color updated
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  itemName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors
                                        .textColorLight, // Text color updated
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
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Have Queries?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColorDark,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Chat with the seller',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.textColorDark,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                print("hello");
                              },
                              icon: const Icon(
                                CommunityMaterialIcons.message_bulleted,
                                size: 24,
                                color: Colors.white, // Icon color
                              ),
                              label: const Text(
                                'Chat',
                                style: TextStyle(
                                  color: Colors.white, // Chat text color
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondaryColor,
                                // Button background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
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
          ],
        ),
      ),
    );
  }
}
