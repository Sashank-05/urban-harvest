import 'package:flutter/material.dart';
class ChilliGuide extends StatefulWidget {
  const ChilliGuide({super.key});

  @override
  State<ChilliGuide> createState() => _ChilliGuideState();
}

class _ChilliGuideState extends State<ChilliGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('chilli'),
        ),
      ),
    );
  }
}
