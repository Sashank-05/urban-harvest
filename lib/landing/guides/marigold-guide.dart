import 'package:flutter/material.dart';
class MarigoldGuide extends StatefulWidget {
  const MarigoldGuide({super.key});

  @override
  State<MarigoldGuide> createState() => _MarigoldGuideState();
}

class _MarigoldGuideState extends State<MarigoldGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Marigold'),
        ),
      ),
    );
  }
}
