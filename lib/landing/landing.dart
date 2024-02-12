import 'package:flutter/material.dart';
import 'package:urban_harvest/constant_colors.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        toolbarOpacity: 0,
        title: const Text(
          "Urban Harvest",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 5),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'What do you want to grow today?',
                      hintStyle: TextStyle(color: AppColors.secondaryColor),
                      prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5)
            ],
          ),
          // Display pictures based on search query
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _getPicturesCount(searchQuery),
              itemBuilder: (context, index) {
                return _buildPictureWidget(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to get the number of pictures to display based on search query
  int _getPicturesCount(String query) {
    // For simplicity, return a fixed number of pictures
    // You can replace this logic with your own search implementation
    if (query.isEmpty) {
      return 0; // No pictures to display if search query is empty
    } else {
      return 4; // Display 4 pictures for any non-empty search query
    }
  }

  // Function to build a picture widget based on index
  Widget _buildPictureWidget(int index) {
    // For demonstration, create a placeholder picture widget
    // Replace this with your own logic to load pictures dynamically
    return Container(
      color: Colors.grey.withOpacity(0.5),
      child: Center(
        child: Text(
          'Picture ${index + 1}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
