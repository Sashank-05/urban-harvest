import 'package:flutter/material.dart';
import 'package:urban_harvest/constant_colors.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 0,
        title: const Text("Urban Harvest", style: TextStyle(
          fontFamily: 'Montserrat',
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
