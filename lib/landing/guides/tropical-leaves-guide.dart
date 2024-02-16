import 'package:flutter/material.dart';

class CurryLeavesGuide extends StatefulWidget {
  const CurryLeavesGuide({super.key});

  @override
  State<CurryLeavesGuide> createState() => _CurryLeavesGuideState();
}

class _CurryLeavesGuideState extends State<CurryLeavesGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Curry Leaves'),
        ),
      ),
    );
  }
}
