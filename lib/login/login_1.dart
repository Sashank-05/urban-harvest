import 'package:flutter/material.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:urban_harvest/landing/landing.dart';

class LoginPage1 extends StatefulWidget {
  const LoginPage1({Key? key}) : super(key: key);
  @override
  State<LoginPage1> createState() => _LoginPage1State();
}

class _LoginPage1State extends State<LoginPage1> {
  bool checked=false;

  @override
  Widget build(BuildContext context) {
    bool ischecked=false;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor2,
        title: const Text(
          "Urban Harvest",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(CommunityMaterialIcons.help_circle,
                color: Colors.white, size: 20),
            onPressed: question_pressed(),
          ),
        ],
      ),

      body: Column(
        children: <Widget>[
          SizedBox(
   height:250,
            width:400,
            child: Image.asset('assets/img/agriculture.jpg',fit:BoxFit.cover, ),
          ),
          Container(
            padding: const EdgeInsets.only(top:5,right:15,bottom:5,left:15),
            child: const Text('Welcome To Urban Harvest',
              textAlign: TextAlign.center,
              style:TextStyle(
                color:Colors.white,
                fontWeight:FontWeight.w700 ,
                fontFamily: 'Montserrat',
                fontSize: 28,
                textBaseline:TextBaseline.ideographic,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top:15,right:25,left:15),
            child: const Text('Grow your own food, plant a tree, or help others in your community',
              textAlign: TextAlign.center,
              style:TextStyle(
                color:AppColors.textColorDark,
                fontWeight:FontWeight.w500 ,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            padding:const EdgeInsets.only(top:15,right:150),
            child:const Text('What is Urban Harvest ?',
                textAlign: TextAlign.left,
                style:TextStyle( color:Colors.white,
                  fontWeight:FontWeight.w700 ,
                  fontSize: 21,
                  //textBaseline:TextBaseline.ideographic,
                )
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Farm Access',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 21,
                  ),
                ),
                Checkbox(
                  value: checked,
                  onChanged: (bool? newValue) {
                    setState(() {
                      checked = newValue ?? false; // Update the checkbox state and UI
                    });
                  },
                ),
              ],
            ),
          ),
         Container(
           padding:const EdgeInsets.only(top:3,right:75),
           child: const Column(
             children: [
             Text('Find local farmers and community gardens',
             textAlign: TextAlign.center,
             style:TextStyle(
               color:AppColors.textColorDark,
               fontWeight:FontWeight.w500 ,
               fontSize: 15,
             ),
           ),
             Text('Get access for land to start your own farm',
                textAlign: TextAlign.center,
                style:TextStyle(
                   color:AppColors.textColorDark,
                   fontWeight:FontWeight.w500 ,
                   fontSize: 15,
                 ),
               ),
             ],
           )
         ),
        Container(
          padding:const EdgeInsets.only(top:20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if (!mounted) return;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const LandingPage())
                  );
                },
                icon: const Icon(CommunityMaterialIcons.sprout,size:45,color:Colors.green,), // Define an icon here
                label: const Text('Select plants you grow'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  list_farm();
                  print('Button pressed');
                },
                icon: const Icon(CommunityMaterialIcons.map_search,size:45,color: Colors.black,), // Define an icon here
                label: const Text('Find Plants to grow'),
              ),
            ],
          ),

           )

        ],
      ),
    );
  }

 question_pressed() {}
}



list_farm(){

}

