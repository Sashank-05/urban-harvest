import 'package:flutter/material.dart';
class CabbageGuide extends StatefulWidget {
  const CabbageGuide({super.key});

  @override
  State<CabbageGuide> createState() => _CabbageGuideState();
}

class _CabbageGuideState extends State<CabbageGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('cabbage'),
        ),
      ),
    );
  }
}
