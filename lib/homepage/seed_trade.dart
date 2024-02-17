import 'package:flutter/material.dart';

import '../constant_colors.dart';

class SeedTradePage extends StatelessWidget {
  const SeedTradePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text(
          "Seed Trade",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.message), // Messages icon
            onPressed: () {
              // Handle messages action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTradeBox("SeedName", "25₹", "beans"),
            const SizedBox(height: 20),
            _buildTradeBox("AnotherSeed", "Swap", "OtherSeed"),
            // Add more trade boxes as needed
          ],
        ),
      ),
    );
  }

  Widget _buildTradeBox(String seedName, String tradeType, String tradeValue) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            seedName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tradeType,
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
