import 'package:flutter/material.dart';
class JasmineGuide extends StatefulWidget {
  const JasmineGuide({super.key});

  @override
  State<JasmineGuide> createState() => _JasmineGuideState();
}

class _JasmineGuideState extends State<JasmineGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Jasmine'
          ),
        ),
      ),
    );
  }
}
