import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:urban_harvest/landing/selectable_landing.dart';

class LoginPage1 extends StatefulWidget {
  const LoginPage1({Key? key}) : super(key: key);

  @override
  State<LoginPage1> createState() => _LoginPage1State();
}

class _LoginPage1State extends State<LoginPage1> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textColorDark),
          backgroundColor: AppColors.backgroundColor2,
          title: Text(
            'Urban Harvest',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: const Color(0xFFD8F3DC)),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 300,
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 70),
                width: 300,
                child: Image.asset(
                  'assets/img/landing/plant.png',
                ),
              ),
              Container(
                color: AppColors.backgroundColor3,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Welcome to',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat',
                                fontSize: 28,
                                textBaseline: TextBaseline.ideographic,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle),
                              child: Image.asset('assets/img/landing/logo.png'),
                            ),
                            Text(
                              'Urban Harvest',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 15, right: 25, left: 15),
                              child: const Text(
                                'A community for rooftop farmers',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.all(20),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const secondWelcomepage()));
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppColors.tertiaryColor2)),
                                    child: const Text(
                                      'Next',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Montserrat',
                                          color: AppColors.primaryColor),
                                    )))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class secondWelcomepage extends StatelessWidget {
  const secondWelcomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textColorDark),
          backgroundColor: AppColors.backgroundColor2,
          title: Text(
            'Urban Harvest',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: const Color(0xFFD8F3DC)),
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 30),
                child: Image.asset(
                  'assets/img/landing/2ndPage.png',
                ),
              ),
              Container(
                color: AppColors.backgroundColor3,
                height: 350,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Learn how to grow a variety of plants with the help of comprehensive guides at your home!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                textBaseline: TextBaseline.ideographic,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.only(top: 30),
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle),
                              child: Image.asset(
                                  'assets/img/landing/gardening.png'),
                            ),
                            Container(
                                margin: const EdgeInsets.all(20),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const thirdWelcomepage()));
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppColors.tertiaryColor2)),
                                    child: const Text(
                                      'Next',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Montserrat',
                                          color: AppColors.primaryColor),
                                    )))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class thirdWelcomepage extends StatefulWidget {
  const thirdWelcomepage({super.key});

  @override
  State<thirdWelcomepage> createState() => _thirdWelcomepageState();
}

class _thirdWelcomepageState extends State<thirdWelcomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textColorDark),
          backgroundColor: AppColors.backgroundColor2,
          title: Text(
            'Urban Harvest',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: const Color(0xFFD8F3DC)),
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 30),
                child: Image.asset(
                  'assets/img/landing/plantdisease.png',
                ),
              ),
              Container(
                color: AppColors.backgroundColor3,
                height: 350,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Detect and find solutions to plant diseases with a picture of the plant!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                textBaseline: TextBaseline.ideographic,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.only(top: 30),
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle),
                              child:
                                  Image.asset('assets/img/landing/camera.png'),
                            ),
                            Container(
                                margin: const EdgeInsets.all(20),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const fourthWelcomepage()));
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppColors.tertiaryColor2)),
                                    child: const Text(
                                      'Next',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Montserrat',
                                          color: AppColors.primaryColor),
                                    )))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class fourthWelcomepage extends StatefulWidget {
  const fourthWelcomepage({super.key});

  @override
  State<fourthWelcomepage> createState() => _fourthWelcomepageState();
}

class _fourthWelcomepageState extends State<fourthWelcomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textColorDark),
          backgroundColor: AppColors.backgroundColor2,
          title: Text(
            'Urban Harvest',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: const Color(0xFFD8F3DC)),
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 30),
                child: Image.asset(
                  'assets/img/landing/network.png',
                ),
              ),
              Container(
                color: AppColors.backgroundColor3,
                height: 350,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Network with other users and find answers to your questions through the forum!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                textBaseline: TextBaseline.ideographic,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.only(top: 30),
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle),
                              child: Image.asset(
                                  'assets/img/landing/comments.png'),
                            ),
                            Container(
                                margin: const EdgeInsets.all(20),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const fifthWelcomepage()));
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppColors.tertiaryColor2)),
                                    child: const Text(
                                      'Next',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Montserrat',
                                          color: AppColors.primaryColor),
                                    )))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class fifthWelcomepage extends StatefulWidget {
  const fifthWelcomepage({super.key});

  @override
  State<fifthWelcomepage> createState() => _fifthWelcomepageState();
}

class _fifthWelcomepageState extends State<fifthWelcomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textColorDark),
          backgroundColor: AppColors.backgroundColor2,
          title: Text(
            'Urban Harvest',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: const Color(0xFFD8F3DC)),
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 30),
                child: Image.asset(
                  'assets/img/landing/trade.png',
                ),
              ),
              Container(
                color: AppColors.backgroundColor3,
                height: 350,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Trade or sell your produce with other users!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                textBaseline: TextBaseline.ideographic,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.only(top: 30),
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle),
                              child:
                                  Image.asset('assets/img/landing/surplus.png'),
                            ),
                            Container(
                                margin: const EdgeInsets.all(20),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const sixthWelcomepage()));
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppColors.tertiaryColor2)),
                                    child: const Text(
                                      'Next',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Montserrat',
                                          color: AppColors.primaryColor),
                                    )))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class sixthWelcomepage extends StatefulWidget {
  const sixthWelcomepage({super.key});

  @override
  State<sixthWelcomepage> createState() => _sixthWelcomepageState();
}

class _sixthWelcomepageState extends State<sixthWelcomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textColorDark),
          backgroundColor: AppColors.backgroundColor2,
          title: Text(
            'Urban Harvest',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: const Color(0xFFD8F3DC)),
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 30),
                child: Image.asset(
                  'assets/img/landing/joincom.png',
                ),
              ),
              Container(
                color: AppColors.backgroundColor3,
                height: 350,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Join the growing community of rooftop farmers!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                textBaseline: TextBaseline.ideographic,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.only(top: 30),
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle),
                              child: Image.asset('assets/img/landing/grid.png'),
                            ),
                            Container(
                                margin: const EdgeInsets.all(20),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SelectableLandingPage()));
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppColors.tertiaryColor2)),
                                    child: const Text(
                                      'Find plants to grow!',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Montserrat',
                                          color: AppColors.primaryColor),
                                    )))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
