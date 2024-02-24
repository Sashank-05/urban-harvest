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
  late Position _userPosition;

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
      final address = _convertLatLonToAddress(location); // Optional conversion

      return Padding( // Add Padding widget here
        padding: const EdgeInsets.symmetric(vertical: 8), // Adjust the vertical spacing as needed
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
            address: address,
          ),
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
              const Text("for", style: TextStyle(color: AppColors.primaryColor)),
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
    ));
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
        backgroundColor: AppColors.backgroundColor2,
        title: Text(itemName,
        style: const TextStyle(
          fontWeight:FontWeight.w600,
          color: AppColors.primaryColor,
        ),
        ),
      ),
      body: Container(
          decoration:  const BoxDecoration(
          color: AppColors.backgroundColor,

          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: AppColors.tertiaryColor2

              ),

              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 300,
                      width:700,
                      padding:const EdgeInsets.only(top:20,right:5,left:5,bottom:10) ,
                      child: Image.network(trade.get('image'),
                        //width: MediaQuery.of(context).size.width * 0.9,
                        //height: MediaQuery.of(context).size.height * 0.25,
                        fit: BoxFit.cover,
                      ),
                      ),
                    const SizedBox(height:20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                              padding:const EdgeInsets.all(6) ,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: AppColors.primaryColor
                            ),
                              child: Text('Trade Type: ${tradeItems[0]}',
                              style:const TextStyle(
                                fontSize: 17,
                              )
                              )
                          ),
                        ),
                    const SizedBox(width:10,),
                    Expanded(
                      child: Container(
                          padding:const EdgeInsets.all(6) ,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: AppColors.primaryColor
                          ),
                          child: Text('Trade Value: ${tradeItems[1]}',
                          style: const TextStyle(
                            fontSize: 17,
                          ),)
                      ),
                    ),
                    // Add more details here as needed
                ],
              ),
                    const SizedBox(height: 20,),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: AppColors.backgroundColor3
                        ),
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(6),
                                child: Text('Have Queries ?? 🤔',
                                style: TextStyle(
                                  fontSize: 18,
                                    color: AppColors.textColorDark
                                ),
                                ),
                              ),


                           const SizedBox(height:5),

                            const Padding(
                              padding: EdgeInsets.all(6),
                              child: Text('Chat with seller ? ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.textColorDark
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 60,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    print("hello");
                                  },
                                  icon: const Icon(
                                  CommunityMaterialIcons.message_bulleted,
                                  size: 40,
                                  color: Colors.black,
                                ),
                                  label: const Text('chat'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

    );
  }


}
