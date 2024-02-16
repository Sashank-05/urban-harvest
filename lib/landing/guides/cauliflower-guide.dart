import 'package:flutter/material.dart';
class CauliflowerGuide extends StatefulWidget {
  const CauliflowerGuide({super.key});

  @override
  State<CauliflowerGuide> createState() => _CauliflowerGuideState();
}

class _CauliflowerGuideState extends State<CauliflowerGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('cauli'),
        ),
      ),
    );
  }
}
