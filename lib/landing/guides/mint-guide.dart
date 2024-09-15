import 'package:flutter/material.dart';

class MintGuide extends StatefulWidget {
  const MintGuide({super.key});

  @override
  State<MintGuide> createState() => _MintGuideState();
}

class _MintGuideState extends State<MintGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mint'),
        ),
      ),
    );
  }
}
