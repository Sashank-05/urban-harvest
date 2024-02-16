import 'package:flutter/material.dart';
class TomatoGuide extends StatefulWidget {
  const TomatoGuide({super.key});

  @override
  State<TomatoGuide> createState() => _TomatoGuideState();
}

class _TomatoGuideState extends State<TomatoGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tomato'),
        ),
      ),
    );
  }
}
