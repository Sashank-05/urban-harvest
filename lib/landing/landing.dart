import 'package:flutter/material.dart';
import 'package:urban_harvest/constant_colors.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor2,
        toolbarOpacity: 0,
        title: const Text("Urban Harvest", style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight:FontWeight.bold ,
          color: AppColors.primaryColor,

        )),
      ),
      body: const Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
