import 'package:flutter/material.dart';
import 'package:urban_harvest/homepage/homepage.dart';
import 'package:urban_harvest/landing/plant_list.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF081C15),
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10),
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
          child: Text('Skip for now'),
        ),
      ),
    ));
  }
}

class PlantCard extends StatefulWidget {
  final String plantName;

  const PlantCard({super.key, required this.plantName});

  @override
  State<PlantCard> createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> {
  @override
  Widget build(BuildContext context) {
    String imgPath = imageDict[widget.plantName] ?? '';

    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF2D6A4F), width: 3),
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xFF1B4332)),
      child: Column(
        children: [
          Image.asset(
            imgPath,
            width: 100,
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              widget.plantName,
              style: GoogleFonts.montserrat(
                  color: const Color(0xFFD8F3DC), fontSize: 17),
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
      {super.key, required this.categoryName, required this.plantWidgets});

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
          padding: const EdgeInsets.all(8),
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

  const searchResults({super.key, required this.searchString});

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
