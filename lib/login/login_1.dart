import 'package:flutter/material.dart';
import 'package:urban_harvest/constant_colors.dart';
import 'package:community_material_icon/community_material_icon.dart';

class LoginPage_1 extends StatefulWidget {
  const LoginPage_1({Key? key}) : super(key: key);

  @override
  _LoginPage_1State createState() => _LoginPage_1State();
}

class _LoginPage_1State extends State<LoginPage_1> {
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
        Container(
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

