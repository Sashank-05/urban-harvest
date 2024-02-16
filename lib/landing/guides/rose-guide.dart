import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
  void initState(){
    final ChooseRoseID = YoutubePlayer.convertUrlToId(ChooseRoseUrl);
    _controllerRoseChoose = YoutubePlayerController(initialVideoId: ChooseRoseID!,flags: const YoutubePlayerFlags(
      autoPlay: false
    ));
    final PottingMixId = YoutubePlayer.convertUrlToId(PottingMixUrl);
    _controllerPottingMix =YoutubePlayerController(initialVideoId: PottingMixId!,flags: const YoutubePlayerFlags(autoPlay: false));
    final WateringCanId = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=HPBuJZO4uxE");
    _controllerWateringCan = YoutubePlayerController(initialVideoId: WateringCanId!,flags: const YoutubePlayerFlags(autoPlay: false));
    final HumidityTrayId = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=QNZTVfobDmA");
    _controllerHumidityTray = YoutubePlayerController(initialVideoId: HumidityTrayId!, flags: const YoutubePlayerFlags(autoPlay: false));
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
          icon: Padding(
              padding: EdgeInsets.only(top: 15), child: Icon(Icons.arrow_back)),
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
              'Guide to growing Roses',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: const Color(0xFFD8F3DC)),
            ),
          ),
        ),
        ),
        backgroundColor: Color(0xFF081C15),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xFF1B4332)),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("Materials Required",
                      style: GoogleFonts.montserrat(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD8F3DC))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(top:10,bottom:20,left:20, right: 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(0xFF2D6A4F)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListItem(
                          'Rose Plant', 'Select a healthy rose plant suitable for indoor growth.'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Refer to the following video if required:',style: GoogleFonts.montserrat(fontSize: 15, color: Color(0xFFD8F3DC))),
                      ),
                      YoutubePlayer(controller: _controllerRoseChoose, showVideoProgressIndicator: true,)
                    ]
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:10,bottom:20,left:20, right: 20),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFF2D6A4F)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListItem(
                          'Pot', 'Choose a pot with good drainage holes and sufficient size for the root system.'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Refer to the following image:',style: GoogleFonts.montserrat(fontSize: 15, color: Color(0xFFD8F3DC))),
                      ),
                      Image.network("https://donotdisturbgardening.com/wp-content/uploads/2019/10/Pots-with-Drainage-Holes.jpg")
                    ]
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:10,bottom:20,left:20, right: 20),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFF2D6A4F)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListItem(
                          'Potting Mix', 'Use well-draining potting soil suitable for roses.'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Guide make it at home:',style: GoogleFonts.montserrat(fontSize: 15, color: Color(0xFFD8F3DC))),
                      ),
                      YoutubePlayer(controller: _controllerPottingMix, showVideoProgressIndicator: true,)
                    ]
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:10,bottom:20,left:20, right: 20),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFF2D6A4F)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListItem(
                          'Watering Can', 'For watering the plant.'),
                      Image.network("https://m.media-amazon.com/images/I/51Oi8t6TEHL.jpg"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Guide make it at home:',style: GoogleFonts.montserrat(fontSize: 15, color: Color(0xFFD8F3DC))),
                      ),
                      YoutubePlayer(controller: _controllerWateringCan, showVideoProgressIndicator: true,)
                    ]
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:10,bottom:20,left:20, right: 20),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFF2D6A4F)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListItem(
                          'Pruning Shears', 'To trim and shape the plant.'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Refer to the following image:',style: GoogleFonts.montserrat(fontSize: 15, color: Color(0xFFD8F3DC))),
                      ),
                      Image.network("https://upload.wikimedia.org/wikipedia/commons/b/b1/Secateur_ouvert.jpg")
                    ]
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:10,bottom:10,left:20, right: 20),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFF2D6A4F)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListItem(
                          'Sunlight', 'Ensure access to adequate sunlight or artificial grow lights.'),
                    ]
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:10,bottom:10,left:20, right: 20),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFF2D6A4F)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListItem(
                          'Humidity Tray', 'Optional, to increase humidity around the plant.'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Guide make it at home:',style: GoogleFonts.montserrat(fontSize: 15, color: Color(0xFFD8F3DC))),
                      ),
                      YoutubePlayer(controller: _controllerHumidityTray, showVideoProgressIndicator: true,)
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Color(0xFF2D6A4F)),
            onPressed: () {

              // Navigator.pushAndRemoveUntil(
                // context,
                // MaterialPageRoute(builder: (context) => const GrowingInstructions()),
                    // (route) => false, // Remove all routes from the stack
              // );
              null;
            },
            child: Text('Next: Setting up your Rose plant!', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,color: Color(0xFFD8F3DC)),),
          ),
        ),
      ),
    );
  }
}

Widget _buildListItem(String heading, String text) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\u2022 ',
          style: GoogleFonts.montserrat(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD8F3DC)),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
                style: GoogleFonts.montserrat(
                    fontSize: 15.0, color: Color(0xFFD8F3DC)),
                children: [
                  TextSpan(
                      text: '$heading: ',
                      style: GoogleFonts.montserrat(
                          fontSize: 15.0,
                          color: Color(0xFFD8F3DC),
                          fontWeight: FontWeight.bold)),
                  TextSpan(text: text)
                ]),
          ),
        ),
      ],
    ),
  );
}
