import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;
import 'package:image_picker/image_picker.dart';

import '../constant_colors.dart';

class InferenceResultPage extends StatelessWidget {
  final File imageFile;
  final String inferenceResult;

  const InferenceResultPage({
    required this.imageFile,
    required this.inferenceResult,
  });

  @override
  Widget build(BuildContext context) {
    String result = inferenceResult.split('___').last.replaceAll('_', ' ');

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFFD8F3DC),
          iconSize: 25,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Inference Result',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.backgroundColor3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: const Text(
                          'Picture used for inference',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: AppColors.primaryColor,
                              fontSize: 20),
                        )),
                    Flexible(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppColors.tertiaryColor2),
                          padding: const EdgeInsets.all(20),
                          child: Image.file(imageFile, width: 300, height: 300,)),
                    ),
                  ],
                )),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColors.backgroundColor3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Detected plant condition',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: AppColors.tertiaryColor2, borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    "Likely $result",
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColors.backgroundColor3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Solution',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: AppColors.tertiaryColor2, borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: const Text(
                    'For a quick, organic solution to common maize rust, prioritize planting resistant varieties. If rust appears, act fast! Mix 1 tablespoon of potassium bicarbonate per gallon of water and spray undersides of leaves every 7-10 days. Boost plant health with diluted compost tea around the base. Remember, early action is key!',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InferencePage extends StatefulWidget {
  @override
  _InferencePageState createState() => _InferencePageState();
}

class _InferencePageState extends State<InferencePage> {
  late Interpreter _interpreter;
  late List<String> _classes;
  String _result = 'Select an image to run inference';

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      // Load the TFLite model
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');

      // Load classes
      var classFile = await rootBundle.loadString('assets/classes.txt');
      _classes = classFile.split('\n');

      setState(() {
        _result = 'Model loaded successfully';
      });
    } catch (e) {
      setState(() {
        _result = 'Failed to load model: $e';
      });
    }
  }

  Future<void> _runInference(BuildContext context, File imageFile) async {
    try {
      final inputDetails = _interpreter.getInputTensors();
      final outputDetails = _interpreter.getOutputTensors();
      // print(inputDetails[0].shape);

      // Read and resize the image
      final imageBytes = await imageFile.readAsBytes();
      final inputImage = imglib.decodeImage(Uint8List.fromList(imageBytes))!;
      final inputImageResized = imglib.copyResize(inputImage,
          width: inputDetails[0].shape[1], height: inputDetails[0].shape[2]);

      // Normalize pixel values
      final inputBytes = Float32List(1 * 256 * 256 * 3);
      var pixelIndex = 0;
      for (var y = 0; y < inputDetails[0].shape[1]; y++) {
        for (var x = 0; x < inputDetails[0].shape[2]; x++) {
          final pixel = inputImageResized.getPixel(x, y);
          inputBytes[pixelIndex++] = imglib.getRed(pixel) / 255.0;
          inputBytes[pixelIndex++] = imglib.getGreen(pixel) / 255.0;
          inputBytes[pixelIndex++] = imglib.getBlue(pixel) / 255.0;
        }
      }

      // Reshape input tensor
      final input = inputBytes
          .reshape([1, inputDetails[0].shape[1], inputDetails[0].shape[2], 3]);
      final output = Float32List(1 * 38).reshape([1, 38]);
      _interpreter.run(input, output);

      final outputData = output[0] as List<double>;
      print(outputData);
      // Print confidence scores for all diseases
     // for (int i = 0; i < outputData.length; i++) {
       // print('${_classes[i]}: ${outputData[i]}');
     // }
      final predictedClassIdx =
          outputData.indexOf(outputData.reduce((a, b) => a > b ? a : b));
      final predictedClass = _classes[predictedClassIdx];

      // Update UI or state
      setState(() {
        _result = '$predictedClass';
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InferenceResultPage(
            imageFile: imageFile,
            inferenceResult: _result,
          ),
        ),
      );
    } catch (e) {
      // Handle any errors
      setState(() {
        _result = 'Failed to run inference: $e';
      });
    }
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      await _runInference(context, File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor2,
        leading: IconButton(
          icon: const Padding(
              padding: EdgeInsets.only(top: 15), child: Icon(Icons.arrow_back)),
          color: const Color(0xFFD8F3DC),
          iconSize: 25,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Detect Disease',
          style: TextStyle(
              fontFamily: 'Montserrat', color: AppColors.primaryColor),
        ),

      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset('assets/img/landing/plantdisease.png'),
            const Padding(
              padding: EdgeInsets.only(bottom: 40.0, left: 20, right: 20),
              child: Center(
                child: Text(
                  'Know what is Ailing your Plant with a Click!',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () => _pickImage(context, ImageSource.camera),
              icon: Image.asset(
                'assets/img/camera.png',
                width: 30,
                height: 30,
              ),
              label: const Text(
                'Take a Picture',
                style: TextStyle(
                    color: AppColors.textColorDark, fontFamily: 'Montserrat'),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiaryColor2,
                  fixedSize: const Size(350, 50)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _pickImage(context, ImageSource.gallery),
              icon: Image.asset(
                'assets/img/gallery.png',
                height: 30,
                width: 30,
              ),
              label: const Text(
                'Pick an Image from Gallery',
                style: TextStyle(
                    color: AppColors.textColorDark, fontFamily: 'Montserrat'),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiaryColor2,
                  fixedSize: const Size(350, 50)),
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
