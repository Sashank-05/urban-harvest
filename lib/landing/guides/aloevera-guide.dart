import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '/homepage/homepage.dart';

class AloeveraGuide extends StatefulWidget {
  const AloeveraGuide({super.key});

  @override
  State<AloeveraGuide> createState() => _AloeveraGuideState();
}

class _AloeveraGuideState extends State<AloeveraGuide> {
  late YoutubePlayerController _controllerAloeveraChoose;
  late YoutubePlayerController _controllerPottingMix;
  late YoutubePlayerController _controllerWateringCan;
  @override
  void initState() {
    final AloeveraChooseId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=gcNNbVaTm0U");
    _controllerAloeveraChoose = YoutubePlayerController(
        initialVideoId: AloeveraChooseId!,
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
                'Guide to growing Aloevera',
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
                        _buildListItem('Aloevera Plant',
                            'Obtain a healthy Aloe vera plant from a nursery or garden center.'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Refer to the following video if required:',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  color: const Color(0xFFD8F3DC))),
                        ),
                        YoutubePlayer(
                          controller: _controllerAloeveraChoose,
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
                        _buildListItem('Pot',
                            'Choose a pot with good drainage holes and sufficient size for the root system.'),
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
                            'Use well-draining potting soil suitable for roses.'),
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
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A4F)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingUp()),
              );
            },
            child: Text(
              'Next: Setting up your Aloevera plant!',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, color: const Color(0xFFD8F3DC)),
            ),
          ),
        ),
      ),
    );
  }
}

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

class SettingUp extends StatefulWidget {
  const SettingUp({super.key});

  @override
  State<SettingUp> createState() => _SettingUpState();
}

class _SettingUpState extends State<SettingUp> {
  late YoutubePlayerController _controllerAloeveraSetup;
  @override
  void initState() {
    final AloeveraSetupId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=-sSgIsihIag");
    _controllerAloeveraSetup = YoutubePlayerController(
        initialVideoId: AloeveraSetupId!,
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
                'Setting up your Aloevera plant',
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
                          controller: _controllerAloeveraSetup,
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
                          'Choose a Suitable location',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Sunlight',
                            'Place the Aloe vera plant in a location with bright, indirect sunlight. A south- or west-facing window indoors is ideal.'),
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
                          'Prepare the pot',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Drainage Holes',
                            'Choose a pot with drainage holes at the bottom to prevent waterlogging.'),
                        _buildListItem('Fill the pot',
                            'Ensure the pot you select has proper drainage holes at the bottom to prevent waterlogging. Fill the pot with well-draining potting mix suitable for succulents or cacti. You can create your mix by combining cactus soil with perlite or sand for improved drainage.'),
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
                          'Planting',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Preparing the Aloevera',
                            'Carefully transplant the Aloe vera plant into the prepared pot, ensuring the roots are covered with soil and the plant sits firmly in the pot. Avoid burying the stem too deeply into the soil, as this can lead to rotting.'),
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
                        _buildListItem('Water lightly',
                            'Water the newly potted Aloe vera plant lightly to settle the soil around the roots. After planting, allow the soil to dry out completely before the next watering session. Overwatering can cause root rot and other issues, so its essential to maintain a balance.'),
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
                          'Sunlight Exposure',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Adequate Sunlight',
                            'Place the potted Aloe vera plant in a location with adequate sunlight. Aloe vera requires at least 6 hours of indirect sunlight per day to thrive. Monitor the plants exposure and adjust its placement as needed to ensure it receives optimal light conditions.'),
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
                          'Temperature & Humidity',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Prevent Stress',
                            'Aloe vera prefers temperatures between 60°F to 80°F (15°C to 27°C). Keep the plant away from drafts or extreme temperature fluctuations, as they can stress the plant. Aloe vera is tolerant of low humidity levels but benefits from occasional misting during dry periods.'),
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
                          'Consistent Care',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Maintenance',
                            'Regularly inspect the Aloe vera plant for signs of pests or diseases. Remove any dead or yellowing leaves to maintain the plants health and appearance. Repot the plant into a larger container if it outgrows its current pot, typically every 2-3 years.'),
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
                          'Frequency',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Drought tolerant',
                            'Aloe vera plants are succulents, meaning they store water in their fleshy leaves and roots. As a result, they are quite drought-tolerant and can withstand periods of dryness. Its essential to allow the soil to dry out between waterings to prevent root rot and other moisture-related issues.'),
                        _buildListItem('Infrequent watering',
                            'Water your Aloe vera plant deeply but infrequently. Aim to water the plant about once every 2-3 weeks during the growing season (spring and summer). In winter, when the plant is in a semi-dormant state, reduce watering frequency to once a month or less, depending on environmental conditions.'),
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
                          'Amount',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Thoroughly saturated soil',
                            'When watering your Aloe vera plant, ensure that you thoroughly soak the soil around the root zone. Water the plant until excess moisture begins to drain from the bottom of the pot, indicating that the soil is saturated.'),
                        _buildListItem('Allow excess water to drain',
                            'Allow excess water to drain away from the pot or planting area.'),
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
                          'Soil Moisture',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Check Soil moisture',
                            'Before watering, check the moisture level of the soil by inserting your finger into the soil up to the first knuckle. If the soil feels dry to the touch, its time to water. If the soil still feels moist, postpone watering for a few more days and recheck.'),
                        _buildListItem('Aloevera prefer dry conditions',
                            'Aloe vera plants prefer slightly dry conditions, so its better to err on the side of underwatering rather than overwatering. Allow the soil to dry out completely between waterings to mimic the plants natural habitat.'),
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
                          'Water Quality',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Room temperature',
                            'Use room temperature water for watering your Aloe vera plant, as cold water can shock the roots. If possible, allow tap water to sit for 24 hours to dissipate any chlorine or fluoride present, as these chemicals can harm the plant over time.'),
                        _buildListItem('Rain water or distilled water',
                            'Rainwater or distilled water is ideal for watering Aloe vera plants, as they are free from harmful chemicals and additives found in tap water.'),
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
