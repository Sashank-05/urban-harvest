import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constant_colors.dart';

class SeedTradeContent extends StatefulWidget {
  const SeedTradeContent({super.key});

  @override
  State<SeedTradeContent> createState() => _SeedTradeContentState();
}

class _SeedTradeContentState extends State<SeedTradeContent> {
  final _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot>? _tradesStream;

  @override
  void initState() {
    super.initState();
    _tradesStream = _firestore.collection('Trades').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser);
    if (FirebaseAuth.instance.currentUser != null) {
      print("user is signed in");
    } else {
      print("User is signed out");
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text("Trade Seeds",style: TextStyle(color: AppColors.primaryColor),),
        actions: [IconButton(
          icon: const Icon(Icons.message),
          color: AppColors.primaryColor,
          onPressed: () {
            // Implement message functionality (navigation, etc.)
          },
        ),]
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30,),
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

                return SingleChildScrollView(
                  child: Column(
                    children: tilesFromTrades(trades),
                  ),
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

      return _buildTradeBox(
        itemName,
        tradeItems[0] as String, // Assuming first item is trade type
        tradeItems[1] as String, // Assuming second item is trade value
        imageUrl: imageUrl,
        address: address,
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
}
