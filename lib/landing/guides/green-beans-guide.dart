import 'package:flutter/material.dart';

class GreenBeansGuide extends StatefulWidget {
  const GreenBeansGuide({super.key});

  @override
  State<GreenBeansGuide> createState() => _GreenBeansGuideState();
}

class _GreenBeansGuideState extends State<GreenBeansGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GreenBeans'),
        ),
      ),
    );
  }
}
