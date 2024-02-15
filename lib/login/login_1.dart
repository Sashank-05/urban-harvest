import 'package:flutter/material.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:community_material_icon/community_material_icon.dart';

class loginPage1 extends StatefulWidget {
  const loginPage1({Key? key}) : super(key: key);

  @override
  State<loginPage1> createState() => _loginPage1State();
}

class _loginPage1State extends State<loginPage1> {
  @override
  Widget build(BuildContext context) {
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
        actions:<Widget>[
          IconButton(
            icon:const Icon(CommunityMaterialIcons.help_circle,color:Colors.white,size:20),
            onPressed: question_pressed(),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
        SizedBox(
            height:300,
            width:400,
            child: Image.asset('assets/img/agri.jpg',fit:BoxFit.cover, ),
        ),
        Container(
          child: const Text('Welcome To Urban Harvest',
          style:TextStyle(
            color:AppColors.textColorDark,
          ),
          )


        ),
          ],

        ),
      );
}
  question_pressed() {}
}

