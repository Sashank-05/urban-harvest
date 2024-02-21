import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;
import 'package:image_picker/image_picker.dart';

import '../constant_colors.dart';

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
        _result = 'Predicted plant condition: $predictedClass';
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
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar( backgroundColor: AppColors.backgroundColor2,
        leading: IconButton(
          icon: Padding(
              padding: EdgeInsets.only(top: 15), child: Icon(Icons.arrow_back)),
          color: Color(0xFFD8F3DC),
          iconSize: 25,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Detect Dieases ', style: TextStyle(
        fontFamily: 'Montserrat',
        color: AppColors.primaryColor),
       ),
      ),
    body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 40.0,left: 20,right: 20),
              child: Text(
                'Know what is Ailing your Plant with a Click!',
                style: TextStyle(
                    color: AppColors.textColorDark,
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(onPressed: () => _pickImage(ImageSource.camera), icon:Image.asset('assets/img/camera.png',width: 40,height: 40,), label: Text('Take a Picture',style: TextStyle(color: AppColors.textColorDark,fontFamily: 'Montserrat'),),style: ElevatedButton.styleFrom(backgroundColor: AppColors.tertiaryColor2,fixedSize: const Size(350, 50)),)
    ,
            SizedBox(height: 20),

            ElevatedButton.icon(onPressed: () => _pickImage(ImageSource.gallery), icon:Image.asset('assets/img/gallery.png',width: 40,height: 40,), label: Text('Pick an Image from Gallery',style: TextStyle(color: AppColors.textColorDark,fontFamily: 'Montserrat'),),style: ElevatedButton.styleFrom(backgroundColor: AppColors.tertiaryColor2,fixedSize: const Size(350, 50)),)
            ,
            SizedBox(height: 20),
            Text(_result,style: TextStyle(color: AppColors.textColorDark),textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
