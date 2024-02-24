import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:urban_harvest/landing/landing.dart';
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(CommunityMaterialIcons.help_circle,
                color: Colors.white, size: 20),
            onPressed: helpOnTap(),
          ),
        ],
      ),

      body:
         Column(
           children: [
             Flexible(
               flex: 1,
                child:
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 250,
                        width: 400,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)
                        ),
                          child: Image.asset(
                            'assets/img/agriculture.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                    ),
                ),

                    const SizedBox(height: 10,),

                     Flexible(
                       flex: 2,
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Column(
                          children: [
                                 Container(
                                   height:446,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: AppColors.backgroundColor3,),
                                  child: Column(
                                    children: [
                                      Container(

                                       padding:
                                            const EdgeInsets.only(top: 5, right: 15, bottom: 5, left: 15),
                                        child: const Text(
                                          'Welcome ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Montserrat',
                                            fontSize: 28,
                                            textBaseline: TextBaseline.ideographic,
                                          ),
                                        ),
                                      ),

                                   Container(
                                     padding: const EdgeInsets.only(top: 15, right: 25, left: 15),
                                      child: const Text(
                                    'Grow your own food, plant a tree, or help others in your community.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                   const SizedBox(height: 10,),
                                   Padding(
                                     padding: const EdgeInsets.all(3.0),
                                     child: Container(
                                      height: 120,
                                      width: 400,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                       color: AppColors.secondaryColor2,),
                                      child:
                                      Column(
                                         children: [
                                           Container(

                                            padding: const EdgeInsets.only(top: 15),
                                            child: const Text('What is Urban Harvest?',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: AppColors.textColorLight,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 21,
                                                  //textBaseline:TextBaseline.ideographic,
                                                )),
                                          ),
                                         Padding(
                                           padding: const EdgeInsets.all(2.0),
                                           child: Expanded(
                                             child: Container(
                                               width: 390,
                                                 height:65,
                                                 

                                                padding: const EdgeInsets.only(top: 3),
                                                child: const Column(
                                                 children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top:4),
                                                    child: Text(
                                                      'Network of Urban Farmers',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: AppColors.backgroundColor3,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Grow a healthy garden | Trade seeds in locality ',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: AppColors.textColorLight,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                   SizedBox(height:5)
                                                ],
                                              )
                                             ),
                                           ),
                                         ),
                                           const SizedBox(height:5)
                                        ],
                                      ),




                                                                     ),
                                   ),
                                    const SizedBox(height: 6,),

                                    Column(
                                      children: [
                                      Container(
                                         padding: const EdgeInsets.only(top: 30),
                                        child: Column(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                           FractionallySizedBox(
                                             widthFactor: 0.8, // Set width factor to 80% of screen width
                                            child: SizedBox(
                                              height: 60, // Set the height for both buttons
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  if (!mounted) return;
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => const SelectableLandingPage(),
                                                    ),
                                                  );

                                                  if (kDebugMode) {
                                                    print('Button pressed');
                                                  }
                                                },
                                                icon: const Icon(
                                                  CommunityMaterialIcons.sprout,
                                                  size: 45,
                                                  color: Colors.green,
                                                ),
                                                label: const Text('Select plants you grow',),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.secondaryColor2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          FractionallySizedBox(
                                            widthFactor: 0.8, // Set width factor to 80% of screen width
                                            child: SizedBox(
                                              height: 60, // Set the height for both buttons
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  if (!mounted) return;
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => const LandingPage(),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  CommunityMaterialIcons.map_search,
                                                  size: 45,
                                                  color: Colors.black,
                                                ),
                                                label: const Text('Find Plants to grow'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.secondaryColor2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                                  ),
                          ],
                                             ),
                       ),
                     ),

],
         ),

    );
  }

  helpOnTap() {}
}

listFarm() {}
