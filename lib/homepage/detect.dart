import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;
import 'package:image_picker/image_picker.dart';

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

  Future<void> _runInference(File imageFile) async {
    try {
      final inputDetails = _interpreter.getInputTensors();
      final outputDetails = _interpreter.getOutputTensors();
      print(inputDetails[0].shape);

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
      for (int i = 0; i < outputData.length; i++) {
        print('${_classes[i]}: ${outputData[i]}');
      }
      final predictedClassIdx =
      outputData.indexOf(outputData.reduce((a, b) => a > b ? a : b));
      final predictedClass = _classes[predictedClassIdx];

      // Update UI or state
      setState(() {
        _result = 'Predicted class: $predictedClass';
      });
    } catch (e) {
      // Handle any errors
      setState(() {
        _result = 'Failed to run inference: $e';
      });
    }
  }


  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      await _runInference(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inference Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Take a Picture'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Pick an Image from Gallery'),
            ),
            SizedBox(height: 20),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
