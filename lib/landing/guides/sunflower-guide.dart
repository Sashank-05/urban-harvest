import 'package:flutter/material.dart';
class SunflowerGuide extends StatefulWidget {
  const SunflowerGuide({super.key});

  @override
  State<SunflowerGuide> createState() => _SunflowerGuideState();
}

class _SunflowerGuideState extends State<SunflowerGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sunflower'
          ),
        ),
      ),
    );
  }
}
