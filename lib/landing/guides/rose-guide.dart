import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:urban_harvest/homepage/homepage.dart';

class RoseGuide extends StatefulWidget {
  const RoseGuide({super.key});

  @override
  State<RoseGuide> createState() => _RoseGuideState();
}

class _RoseGuideState extends State<RoseGuide> {
  final ChooseRoseUrl = "https://www.youtube.com/watch?v=02QSPNdKIS4";
  final PottingMixUrl = "https://www.youtube.com/watch?v=t3kx5PhCJU8";
  late YoutubePlayerController _controllerRoseChoose;
  late YoutubePlayerController _controllerPottingMix;
  late YoutubePlayerController _controllerWateringCan;
  late YoutubePlayerController _controllerHumidityTray;
  @override
  void initState() {
    final ChooseRoseID = YoutubePlayer.convertUrlToId(ChooseRoseUrl);
    _controllerRoseChoose = YoutubePlayerController(
        initialVideoId: ChooseRoseID!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    final PottingMixId = YoutubePlayer.convertUrlToId(PottingMixUrl);
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
                'Guide to growing Roses',
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
                        _buildListItem('Rose Plant',
                            'Select a healthy rose plant suitable for indoor growth.'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Refer to the following video if required:',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  color: const Color(0xFFD8F3DC))),
                        ),
                        YoutubePlayer(
                          controller: _controllerRoseChoose,
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
                      top: 10, bottom: 20, left: 20, right: 20),
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
                                  fontSize: 15,
                                  color: const Color(0xFFD8F3DC))),
                        ),
                        Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/b/b1/Secateur_ouvert.jpg")
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
                        _buildListItem('Humidity Tray',
                            'Optional, to increase humidity around the plant.'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Guide make it at home:',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  color: const Color(0xFFD8F3DC))),
                        ),
                        YoutubePlayer(
                          controller: _controllerHumidityTray,
                          showVideoProgressIndicator: true,
                        )
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
              'Next: Setting up your Rose plant!',
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
  late YoutubePlayerController _controllerRoseSetup;
  @override
  void initState() {
    final RoseSetupId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=K01ChwVFrkc");
    _controllerRoseSetup = YoutubePlayerController(
        initialVideoId: RoseSetupId!,
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
                'Setting up your Rose plant',
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
                          controller: _controllerRoseSetup,
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
                            'Select a location that receives at least 6 hours of sunlight per day. If natural light is not available, consider using artificial grow lights.'),
                        _buildListItem('Air-Circulation',
                            'Ensure the area has good air circulation to prevent fungal diseases.'),
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
                            'Fill the pot with well-draining potting soil rich in organic matter. You can also mix in perlite or sand to improve drainage.'),
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
                          'Plant the Rose',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Preparing the rose',
                            'Carefully remove the rose plant from its container and gently loosen the root ball.'),
                        _buildListItem('Placing the rose',
                            'Place the rose plant in the center of the pot and fill in the sides with soil until the roots are covered.'),
                        _buildListItem('Water the plant',
                            'Water the plant thoroughly to settle the soil around the roots.'),
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
                          'Ensure Adequate Watering',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Moist Soil',
                            'Keep the soil consistently moist, but not waterlogged. Check the soil moisture regularly by inserting your finger into the soil.'),
                        _buildListItem('Water the plant',
                            'Water the plant deeply when the top inch of soil feels dry to the touch.'),
                        _buildListItem('Overhead watering',
                            'Avoid overhead watering to prevent fungal diseases.'),
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
                          'Monitor for Pests and Diseases',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Spiders and thrips',
                            'Keep an eye out for common pests such as aphids, spider mites, and thrips.Treat infestations with neem oil'),
                        _buildListItem('Watch for signs',
                            'Watch for signs of fungal diseases such as powdery mildew or black spot. Provide good air circulation and avoid overhead watering to minimize disease risk.'),
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
                          'Growth Support',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Trellises or stakes',
                            'Depending on the variety, roses may benefit from support structures such as trellises or stakes to keep them upright and promote healthy growth.'),
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
                        _buildListItem('Monitor the plant',
                            'Consistently monitor the rose plant for any signs of stress, disease, or nutrient deficiencies.Adjust watering, fertilizing, and pruning practices as needed based on the plants response and seasonal changes.'),
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
                          'Water at the Base:',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Watering at the base',
                            'Direct the water at the base of the rose plant, near the soil level. Avoid watering the foliage, as wet leaves can promote fungal diseases.'),
                        _buildListItem('Gentle Spray attachment',
                            'Use a watering can or hose with a gentle spray attachment to deliver water evenly to the soil.'),
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
                          'Deep Watering',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Water rose plant deeply',
                            'Water the rose plant deeply to encourage deep root growth. Apply water until the soil is thoroughly moistened to the root zone.'),
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
                          'Morning Watering',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Water roses in the morning',
                            'Water roses in the morning to allow foliage and soil to dry out during the day. Watering in the morning helps reduce the risk of fungal diseases and evaporation loss.'),
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
                          'Mulch',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Apply a layer of Mulch',
                            'Apply a layer of organic mulch such as wood chips, straw, or compost around the base of the rose plant.'),
                        _buildListItem('Helps retain moisture',
                            'Mulch helps retain soil moisture, regulate soil temperature, and suppress weed growth. It also reduces water evaporation from the soil surface.'),
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
                          'Watering Frequency',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Deep, infrequent watering',
                            'In general, roses benefit from deep, infrequent watering rather than frequent light watering.Water established rose plants deeply once or twice a week, depending on weather conditions and soil moisture levels.During periods of high heat or drought, increase the frequency of watering to prevent stress on the plants.'),
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
                          'Monitor health',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFFD8F3DC)),
                        ),
                        _buildListItem('Pay attention',
                            'Pay attention to signs of overwatering or underwatering such as yellowing leaves, wilting, or root rot.Adjust your watering schedule based on the plants needs and environmental conditions.'),
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
