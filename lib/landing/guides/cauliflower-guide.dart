import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '/homepage/homepage.dart';


Widget _buildListItem(String heading, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\u2022 ',
          style: GoogleFonts.montserrat(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD8F3DC)),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
                style: GoogleFonts.montserrat(
                    fontSize: 15.0, color: const Color(0xFFD8F3DC)),
                children: [
                  TextSpan(
                      text: '$heading: ',
                      style: GoogleFonts.montserrat(
                          fontSize: 15.0,
                          color: const Color(0xFFD8F3DC),
                          fontWeight: FontWeight.bold)),
                  TextSpan(text: text)
                ]),
          ),
        ),
      ],
    ),
  );
}

class CauliflowerGuide extends StatefulWidget {
  const CauliflowerGuide({super.key});

  @override
  State<CauliflowerGuide> createState() => _CauliflowerGuideState();
}

class _CauliflowerGuideState extends State<CauliflowerGuide> {
  late YoutubePlayerController _controllerPottingMix;
  late YoutubePlayerController _controllerWateringCan;
  @override
  void initState(){
    final PottingMixId = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=t3kx5PhCJU8");
    _controllerPottingMix = YoutubePlayerController(
        initialVideoId: PottingMixId!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    final WateringCanId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=HPBuJZO4uxE");
    _controllerWateringCan = YoutubePlayerController(
        initialVideoId: WateringCanId!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: const Color(0xFF081C15),
          leading: IconButton(
            icon: const Padding(
                padding: EdgeInsets.only(top: 15),
                child: Icon(Icons.arrow_back)),
            color: const Color(0xFFD8F3DC),
            iconSize: 25,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Padding(
            padding: const EdgeInsets.only(right: 50.0, bottom: 40, top: 50),
            child: Center(
              child: Text(
                'Guide to growing Cauliflower',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: const Color(0xFFD8F3DC)),
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF081C15),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFF1B4332)),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("Materials Required",
                      style: GoogleFonts.montserrat(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD8F3DC))),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding:
                      const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildListItem('Cauliflower Seeds',
                            'Choose high-quality cabbage seeds from a reputable nursery.'),
                      ]),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildListItem('Pot or Container',
                            'Select deep containers or pots with drainage holes for planting cauliflower seedlings.'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Refer to the following image:',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15, color: const Color(0xFFD8F3DC))),
                        ),
                        Image.network(
                            "https://donotdisturbgardening.com/wp-content/uploads/2019/10/Pots-with-Drainage-Holes.jpg")
                      ]),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildListItem('Potting Mix',
                            'Use well-draining potting soil suitable for cauliflowers.'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Guide make it at home:',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15, color: const Color(0xFFD8F3DC))),
                        ),
                        YoutubePlayer(
                          controller: _controllerPottingMix,
                          showVideoProgressIndicator: true,
                        )
                      ]),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildListItem(
                            'Watering Can', 'For watering the plant.'),
                        Image.network(
                            "https://m.media-amazon.com/images/I/51Oi8t6TEHL.jpg"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Guide make it at home:',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15, color: const Color(0xFFD8F3DC))),
                        ),
                        YoutubePlayer(
                          controller: _controllerWateringCan,
                          showVideoProgressIndicator: true,
                        )
                      ]),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildListItem('Sunlight',
                            'Ensure access to adequate sunlight or artificial grow lights.'),
                      ]),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D6A4F)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingUp()),
              );
            },
            child: Text(
              'Next: Setting up your Cauliflower',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, color: const Color(0xFFD8F3DC)),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingUp extends StatefulWidget {
  const SettingUp({super.key});

  @override
  State<SettingUp> createState() => _SettingUpState();
}
class _SettingUpState extends State<SettingUp> {
  late YoutubePlayerController _controllerCauliflowerSetup;
  @override
  void initState() {
    final CauliflowerSetupId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=uhFbRyL5Jrc");
    _controllerCauliflowerSetup = YoutubePlayerController(
        initialVideoId: CauliflowerSetupId!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: const Color(0xFF081C15),
          leading: IconButton(
            icon: const Padding(
                padding: EdgeInsets.only(top: 15),
                child: Icon(Icons.arrow_back)),
            color: const Color(0xFFD8F3DC),
            iconSize: 25,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Padding(
            padding: const EdgeInsets.only(right: 50.0, bottom: 40, top: 50),
            child: Center(
              child: Text(
                'Setting up your Cauliflower',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: const Color(0xFFD8F3DC)),
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF081C15),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFF1B4332)),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("Steps to be followed",
                      style: GoogleFonts.montserrat(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD8F3DC))),
                ),
                Container(
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'For a visual guide refer to the following video:',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: const Color(0xFFD8F3DC)),
                          ),
                        ),
                        YoutubePlayer(
                          controller: _controllerCauliflowerSetup,
                          showVideoProgressIndicator: true,
                        )
                      ]),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prepare the pot',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Fill the pot',
                            'Fill the pot or container with well-draining potting mix, leaving about an inch of space from the rim.'),
                      ]),
                ),
                Container(
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Planting the Cauliflower',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Plant the cauliflower',
                            'Plant the cauliflower seeds or seedlings according to the instructions on the seed packet or nursery label. Space the plants appropriately to allow for proper growth.'),
                      ]),
                ),
                Container(
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Watering',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Evenly Moist',
                            'Water the cauliflower plants immediately after planting to settle the soil. Keep the soil evenly moist throughout the growing season to support healthy plant development.'),
                      ]),
                ),
                Container(
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Light Requirements',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('6-8 hrs of sunlight',
                            'Place the pot in a location that receives at least 6-8 hours of sunlight per day or under artificial grow lights. Cauliflower plants require ample sunlight for optimal growth and head formation.'),
                      ]),
                ),
                Container(
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thinning(If neccessary)',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Overcrowded',
                            'If the cauliflower plants become overcrowded, thin them out by removing excess seedlings to allow adequate space for growth.'),
                      ]),
                ),
                Container(
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pest & Disease Management',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Monitor',
                            'Monitor the cauliflower plants regularly for signs of pests, such as aphids or cabbage worms, and diseases. Take appropriate measures, such as using organic pesticides or practicing crop rotation, to prevent and manage pest and disease issues.'),
                      ]),
                ),
                Container(
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Harvesting',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Cut the heads',
                            'Cabbage heads are ready for harvest when they reach their full size and feel firm to the touch.'),
                        _buildListItem('Post Harvest Care',
                            'After harvesting, remove any remaining plant debris from the container and replenish the soil with compost or organic fertilizer to prepare for the next growing season.'),
                      ]),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D6A4F)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WateringInstructions()),
              );
              null;
            },
            child: Text(
              'Next: Watering Instructions',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, color: const Color(0xFFD8F3DC)),
            ),
          ),
        ),
      ),
    );
  }
}

class WateringInstructions extends StatefulWidget {
  const WateringInstructions({super.key});

  @override
  State<WateringInstructions> createState() => _WateringInstructionsState();
}
class _WateringInstructionsState extends State<WateringInstructions> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: const Color(0xFF081C15),
          leading: IconButton(
            icon: const Padding(
                padding: EdgeInsets.only(top: 15),
                child: Icon(Icons.arrow_back)),
            color: const Color(0xFFD8F3DC),
            iconSize: 25,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Padding(
            padding: const EdgeInsets.only(right: 50.0, bottom: 40, top: 50),
            child: Center(
              child: Text(
                'Watering your Plant',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: const Color(0xFFD8F3DC)),
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF081C15),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFF1B4332)),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("Points to keep in mind",
                      style: GoogleFonts.montserrat(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD8F3DC))),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Frequency',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Water regularly',
                            'Water the cauliflower plants regularly to maintain even soil moisture levels. Check the soil moisture by inserting your finger into the soil; if it feels dry to the touch, its time to water.'),
                      ]),
                ),
                Container(
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Avoid Overwatering',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Root Rot',
                            'While its essential to keep the soil consistently moist, avoid overwatering, as waterlogged soil can lead to root rot and other moisture-related issues.'),
                      ]),
                ),
                Container(
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Watering Technique',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Watering hose or Watering Can',
                            'Use a watering can or hose to water the cauliflower plants at the base, near the soil surface. Avoid overhead watering, as it may increase the risk of fungal diseases.'),
                      ]),
                ),
                Container(
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Consistency',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Consistent watering schedule',
                            'Maintain a consistent watering schedule, especially during hot, dry periods or when the cauliflower plants are actively growing. Consistent moisture levels help prevent stress and ensure optimal plant health.'),
                      ]),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D6A4F)),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false, // Remove all routes from the stack
              );
            },
            child: Text(
              'Done setting up!',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, color: const Color(0xFFD8F3DC)),
            ),
          ),
        ),
      ),
    );
  }
}
