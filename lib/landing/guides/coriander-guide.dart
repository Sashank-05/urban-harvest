import 'package:flutter/material.dart';
class CorianderGuide extends StatefulWidget {
  const CorianderGuide({super.key});

  @override
  State<CorianderGuide> createState() => _CorianderGuideState();
}

class _CorianderGuideState extends State<CorianderGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Coriander'),
        ),
      ),
    );
  }
}
