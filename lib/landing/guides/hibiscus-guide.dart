import 'package:flutter/material.dart';
class HibiscusGuide extends StatefulWidget {
  const HibiscusGuide({super.key});

  @override
  State<HibiscusGuide> createState() => _HibiscusGuideState();
}

class _HibiscusGuideState extends State<HibiscusGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hibiscus'),
        ),
      ),
    );
  }
}
