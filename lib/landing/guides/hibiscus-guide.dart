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
class HibiscusGuide extends StatefulWidget {
  const HibiscusGuide({super.key});

  @override
  State<HibiscusGuide> createState() => _HibiscusGuideState();
}

class _HibiscusGuideState extends State<HibiscusGuide> {
  late YoutubePlayerController _controllerSeedChoose;
  late YoutubePlayerController _controllerPottingMix;
  late YoutubePlayerController _controllerWateringCan;
  late YoutubePlayerController _controllerHumidityTray;
  @override
  void initState(){
    final SeedChooseId = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=k_313ix9kO4");
    _controllerSeedChoose = YoutubePlayerController(
        initialVideoId: SeedChooseId!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    final PottingMixId = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=t3kx5PhCJU8");
    _controllerPottingMix = YoutubePlayerController(
        initialVideoId: PottingMixId!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    final WateringCanId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=HPBuJZO4uxE");
    _controllerWateringCan = YoutubePlayerController(
        initialVideoId: WateringCanId!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    final HumidityTrayId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=QNZTVfobDmA");
    _controllerHumidityTray = YoutubePlayerController(
        initialVideoId: HumidityTrayId!,
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
                'Guide to growing Hibiscus',
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
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildListItem('Hibiscus Plant',
                            'Select a healthy hibiscus plant suitable for indoor cultivation.'),
                        YoutubePlayer(
                          controller: _controllerSeedChoose,
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
                        _buildListItem('Pot',
                            'Choose a spacious pot with drainage holes to accommodate the hibiscus root system.'),
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
                            'Use well-draining potting soil rich in organic matter, formulated for flowering plants.'),
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
                        _buildListItem(
                            'Pruning Shears', 'To trim and shape the plant.'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Refer to the following image:',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15, color: Color(0xFFD8F3DC))),
                        ),
                        Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/b/b1/Secateur_ouvert.jpg")
                      ]),
                ),
                Container(
                  padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF2D6A4F)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildListItem('Humidity Tray',
                            'Optional, to increase humidity around the plant.'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Guide make it at home:',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15, color: Color(0xFFD8F3DC))),
                        ),
                        YoutubePlayer(
                          controller: _controllerHumidityTray,
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
                            'Ensure access to plenty of bright, indirect sunlight for optimal growth and flowering.'),
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
              'Next: Setting up your Hibiscus Plant!',
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
  late YoutubePlayerController _controllerHibiscusSetup;
  @override
  void initState() {
    final HibiscusSetupId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=uhFbRyL5Jrc");
    _controllerHibiscusSetup = YoutubePlayerController(
        initialVideoId: HibiscusSetupId!,
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
                'Setting up your Hibiscus Plant',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
                          controller: _controllerHibiscusSetup,
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
                          'Preparing the pot',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Choosing the pot',
                            'Select a pot that is at least one size larger than the plants current container, with adequate drainage holes at the bottom.'),
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
                          'Preparing the potting mix',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Fill the pot',
                            'Fill the pot with well-draining potting soil, leaving enough space to accommodate the plants root ball.'),
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
                          'Planting the Hibiscus',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Place the plant in the pot',
                            'Gently remove the hibiscus plant from its nursery container and place it in the center of the prepared pot. Fill in any gaps with additional potting mix and firm the soil around the plant.'),
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
                        _buildListItem('Thoroughly water',
                            'Water the hibiscus thoroughly after planting to settle the soil and hydrate the roots. Ensure that excess water drains freely from the bottom of the pot.'),
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
                          'Placement',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Sunny Location',
                            'Position the hibiscus plant in a bright, sunny location indoors, preferably near a south-facing window where it can receive ample sunlight.'),
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
                          'Pruning & Shaping',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Periodic Pruning',
                            'Prune the hibiscus plant periodically to promote bushy growth and encourage the development of new blooms. Remove any dead, damaged, or overgrown branches using sterilized pruning shears.'),
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
                          'Monitoring Growth',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Monitor Regularly',
                            'Monitor the hibiscus plant regularly for signs of growth, flowering, and overall health. Adjust watering, fertilizing, and pruning practices as needed to support optimal growth and blooming.'),
                        _buildListItem('Pest and Disease Control',
                            'Keep an eye out for common pests such as aphids, spider mites, and whiteflies. Treat any infestations promptly with organic insecticidal soap or horticultural oil.'),
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
                        _buildListItem('Water thoroughly',
                            'Water the hibiscus plant thoroughly whenever the top inch of soil feels dry to the touch. Aim to maintain even soil moisture levels without allowing the soil to become waterlogged.'),
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
                        _buildListItem('Watering can or gentle spray nozzle',
                            'Use a watering can or a gentle spray nozzle to water the hibiscus plant at the base, near the soil surface. Avoid wetting the foliage, as this can increase the risk of fungal diseases.'),
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
                          'Morning Watering',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Water in the morning',
                            'Water the hibiscus plant in the morning to allow excess moisture to evaporate during the day and reduce the risk of root rot and fungal infections.'),
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
                          'Soil Draining',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Proper pot drainange',
                            'Ensure that the pot has proper drainage holes to allow excess water to escape freely. Remove any excess water that collects in the saucer or tray beneath the pot to prevent waterlogging.'),
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
