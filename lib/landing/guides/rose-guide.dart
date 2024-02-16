import 'package:flutter/material.dart';
class RoseGuide extends StatefulWidget {
  const RoseGuide({super.key});

  @override
  State<RoseGuide> createState() => _RoseGuideState();
}

class _RoseGuideState extends State<RoseGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Rose'),
        ),
      ),
    );
  }
}
