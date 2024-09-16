import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:urban_harvest/homepage/homepage.dart';

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
  late YoutubePlayerController _controllerCauliflowerChoose;
  late YoutubePlayerController _controllerPottingMix;
  late YoutubePlayerController _controllerWateringCan;
  @override
  void initState() {
    final CauliflowerChooseId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=RkiNxNiCAkM");
    _controllerCauliflowerChoose = YoutubePlayerController(
        initialVideoId: CauliflowerChooseId!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    final PottingMixId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=t3kx5PhCJU8");
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
                  child: Text("Materials Required",
                      style: GoogleFonts.montserrat(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD8F3DC))),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildListItem('Cauliflower Seeds',
                            'CChoose high-quality seeds or healthy seedlings from a reputable nursery. Ensure they are suitable for indoor growing.'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Refer to the following video if required:',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  color: const Color(0xFFD8F3DC))),
                        ),
                        YoutubePlayer(
                          controller: _controllerCauliflowerChoose,
                          showVideoProgressIndicator: true,
                        )
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildListItem('Pot or Container',
                            ' Select a spacious container with drainage holes to accommodate the cauliflowers root system and ensure proper drainage.'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Refer to the following image:',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  color: const Color(0xFFD8F3DC))),
                        ),
                        Image.network(
                            "https://donotdisturbgardening.com/wp-content/uploads/2019/10/Pots-with-Drainage-Holes.jpg")
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildListItem('Potting Mix',
                            'Use a well-draining potting mix enriched with organic matter to provide essential nutrients and support healthy plant growth.'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Guide make it at home:',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  color: const Color(0xFFD8F3DC))),
                        ),
                        YoutubePlayer(
                          controller: _controllerPottingMix,
                          showVideoProgressIndicator: true,
                        )
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 20, right: 20),
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
                                  fontSize: 15,
                                  color: const Color(0xFFD8F3DC))),
                        ),
                        YoutubePlayer(
                          controller: _controllerWateringCan,
                          showVideoProgressIndicator: true,
                        )
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildListItem('Sunlight',
                            ' Ensure access to adequate sunlight, typically 6-8 hours per day, or utilize artificial grow lights to provide sufficient light for optimal plant growth.'),
                      ]),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A4F)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingUp()),
              );
            },
            child: Text(
              'Next: Setting up your Cauliflower plant!',
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
                'Setting up your Cauliflower plant',
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
                  child: Text("Steps to be followed",
                      style: GoogleFonts.montserrat(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD8F3DC))),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 20, right: 20),
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
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Germination',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Prepare the Pot',
                            'Fill the container with the chosen potting mix, leaving approximately an inch of space from the rim to prevent overflow when watering.'),
                        _buildListItem('Planting Cauliflower',
                            'If starting from seeds, sow them according to the recommended depth and spacing provided on the seed packet. Cover the seeds lightly with soil and gently water. If using seedlings, carefully transplant them into the prepared container, ensuring they are planted at the appropriate depth and spaced adequately apart to allow for proper growth.'),
                        _buildListItem('Light Requirements',
                            'Place the container in a location that receives ample sunlight, preferably a south-facing window or under grow lights designed for indoor plants. Adequate light is crucial for healthy plant development and the formation of cauliflower heads.'),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 20, right: 20),
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
                        _buildListItem('Evenly Moist soil',
                            'Water the cauliflower plants immediately after planting to settle the soil. Ensure the soil remains consistently moist throughout the growing season.'),
                        _buildListItem('Avoid over watering',
                            'Avoid overwatering, which can lead to root rot. Instead, water the plant as required to prevent moisture-related issues.'),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pest and disease management',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Monitor the Cauliflower',
                            'Regularly inspect the cauliflower plants for signs of pests, such as aphids, caterpillars, or diseases like powdery mildew.'),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fertilization',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Balanced fertilization',
                            'Apply a balanced fertilizer or organic compost to the soil around the cauliflower plants every 2-4 weeks during the growing season to provide essential nutrients for vigorous growth and development.'),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 20, right: 20),
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
                        _buildListItem('Full size',
                            'Cauliflower heads are ready for harvest when they reach their full size and feel firm to the touch.'),
                        _buildListItem('Sharp knife',
                            'Use a sharp knife to cut the Cauliflower heads at the base of the plant, leaving a few outer leaves intact to protect the inner leaves.'),
                      ]),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A4F)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WateringInstructions()),
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
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Moisture level',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Keep soil consistenly moist',
                            'Keep the soil consistently moist throughout the Cauliflower growing season. Cauliflower plants require adequate moisture to support healthy growth and development.'),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
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
                        _buildListItem('Regularly water',
                            'Water the Cauliflower plants regularly, ensuring that the soil remains evenly moist but not waterlogged. Aim to water the plants whenever the top inch of soil feels dry to the touch.'),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 20, right: 20),
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
                        _buildListItem('Watering can or spray nozzle',
                            'Use a watering can or a gentle spray nozzle to water the Cauliflower plants at the base, near the soil surface. Avoid overhead watering, as it can increase the risk of fungal diseases and foliage damage.'),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Soil Drainage',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Proper Drainage holes',
                            'Ensure that the containers or pots have proper drainage holes to allow excess water to escape. Poor drainage can lead to waterlogging, which may cause root rot and other moisture-related issues.'),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 20, right: 20),
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
                            'Maintain a consistent watering schedule, especially during hot, dry periods or when the Cauliflower plants are actively growing. Consistent moisture levels help prevent stress and ensure optimal plant health.'),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 20, right: 20),
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
                        _buildListItem('Root rot',
                            'While its essential to keep the soil consistently moist, avoid overwatering the Cauliflower plants. Soggy, waterlogged soil can lead to root rot and other moisture-related problems. Always check the soil moisture level before watering and adjust as needed.'),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mulching(Optional)',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Apply layer of organic mulch',
                            'Consider applying a layer of organic mulch, such as straw or compost, around the base of the Cauliflower plants. Mulch helps retain soil moisture, reduces water evaporation, and suppresses weed growth.'),
                      ]),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A4F)),
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
