import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urban_harvest/homepage/homepage.dart';
import 'package:urban_harvest/landing/plant_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_harvest/constant_colors.dart';

class SelectableLandingPage extends StatefulWidget {
  const SelectableLandingPage({Key? key});

  @override
  State<SelectableLandingPage> createState() => _SelectableLandingPageState();
}

class _SelectableLandingPageState extends State<SelectableLandingPage> {
  String search = '';
  bool _anyPlantsSelected = false;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((doc) {
      setState(() {
        _anyPlantsSelected = doc.exists && doc.data()?['plants'] != null;
      });
    });

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: const Color(0xFF081C15),
          leading: IconButton(
            icon: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Icon(Icons.arrow_back)),
            color: Color(0xFFD8F3DC),
            iconSize: 25,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Padding(
            padding: const EdgeInsets.only(right: 50.0, bottom: 40, top: 50),
            child: Center(
              child: Text(
                'Urban Harvest',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: const Color(0xFFD8F3DC)),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SearchBar(
                leading: const Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Icon(
                    Icons.search,
                    color: Color(0xFF52B788),
                  ),
                ),
                hintText: 'What do you want to grow?',
                hintStyle: MaterialStateProperty.all<TextStyle>(
                  GoogleFonts.montserrat(color: const Color(0xFF52B788)),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return const Color(0xFF2D6A4F);
                  },
                ),
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
                textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(color: Color(0xFFD8F3DC)),
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(child: searchResults(searchString: search)),
        backgroundColor: const Color(0xFF081C15),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false, // Remove all routes from the stack
              );
            },
            child: Text(_anyPlantsSelected ? 'Next' : 'Skip for now'),
          ),
        ),
      ),
    );
  }
}

class PlantCard extends StatefulWidget {
  final String plantName;

  const PlantCard({Key? key, required this.plantName}) : super(key: key);

  @override
  State<PlantCard> createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    checkIfSelected();
  }

  void checkIfSelected() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(userId);

    userDocRef.get().then((doc) {
      if (doc.exists) {
        // Check if the 'plants' field exists
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('plants')) {
          // Get the current list of selected plants
          List<String> selectedPlants = List<String>.from(data['plants']);
          // Check if the current plant is in the list of selected plants
          setState(() {
            _isSelected = selectedPlants.contains(widget.plantName);
          });
        }
      }
    });
  }

  void _toggleSelection() {
    setState(() {
      _isSelected = !_isSelected;
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('Users').doc(userId);

      // Get the user's document
      userDocRef.get().then((doc) {
        if (doc.exists) {
          // Check if the 'plants' field exists
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('plants')) {
            // Get the current list of selected plants
            List<String> selectedPlants = List<String>.from(data['plants']);

            if (_isSelected) {
              // Add the selected plant to the list
              selectedPlants.add(widget.plantName);
            } else {
              // Remove the deselected plant from the list
              selectedPlants.remove(widget.plantName);
            }

            // Update the list of selected plants in the user's document
            userDocRef.set({'plants': selectedPlants}, SetOptions(merge: true));
          } else {
            // 'plants' field doesn't exist, create it with the selected plant

            userDocRef.set({
              'plants': [widget.plantName]
            }, SetOptions(merge: true));
          }
        } else {
          // User document doesn't exist, create it with the selected plant
          userDocRef.set({
            'plants': [widget.plantName]
          }, SetOptions(merge: true));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String imgPath = imageDict[widget.plantName] ?? '';

    return GestureDetector(
      onTap: _toggleSelection,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(16),
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF2D6A4F), width: 3),
              borderRadius: BorderRadius.circular(30),
              color: _isSelected
                  ? Colors.black.withOpacity(0.5)
                  : const Color(0xFF1B4332),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.asset(
                      imgPath,
                      width: 70,
                      height: 70,
                    ),
                    if (_isSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 5, right: 5),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    widget.plantName,
                    style: GoogleFonts.montserrat(
                      color:
                          _isSelected ? Colors.white : const Color(0xFFD8F3DC),
                      fontSize: 17,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.backgroundColor3)),
                  onPressed: () {
                    for (var i in guideDict.keys) {
                      if (i == widget.plantName) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => guideDict[i]!));
                      }
                    }
                  },
                  child: const Text(
                    'View Guide',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class categoryCard extends StatefulWidget {
  final String categoryName;
  final List<Widget> plantWidgets;

  const categoryCard(
      {Key? key, required this.categoryName, required this.plantWidgets});

  @override
  State<categoryCard> createState() => _categoryCardState();
}

class _categoryCardState extends State<categoryCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.categoryName,
              style: GoogleFonts.montserrat(
                  color: const Color(0xFFD8F3DC),
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ),
        GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: widget.plantWidgets,
          ),

      ],
    );
  }
}

class searchResults extends StatefulWidget {
  final String searchString;

  const searchResults({Key? key, required this.searchString});

  @override
  State<searchResults> createState() => _searchResultsState();
}

class _searchResultsState extends State<searchResults> {
  late List<Widget> plantCategoryList;

  @override
  void initState() {
    super.initState();
    updatePlantCategoryList();
  }

  @override
  void didUpdateWidget(covariant searchResults oldWidget) {
    super.didUpdateWidget(oldWidget);
    updatePlantCategoryList();
  }

  void updatePlantCategoryList() {
    plantCategoryList = [];
    var searchQueryResults1 = searchQueryResults(widget.searchString);
    for (var i in searchQueryResults1.keys) {
      List<Widget> plantList = [];
      for (int a = 0; a < searchQueryResults1[i]!.length; ++a) {
        plantList.add(PlantCard(plantName: searchQueryResults1[i]![a]));
      }
      plantCategoryList
          .add(categoryCard(categoryName: i, plantWidgets: plantList));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: plantCategoryList,
    );
  }
}
