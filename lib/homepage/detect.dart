import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:urban_harvest/homepage/disease/disease_detection.dart';
import 'package:urban_harvest/homepage/disease/classifier.dart'; // Import your classifier class
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart' as tflite_helper;
import 'package:image/image.dart' as img; // Import Image class from the image package

class CameraClassifierPage extends StatefulWidget {
  @override
  _CameraClassifierPageState createState() => _CameraClassifierPageState();
}

class _CameraClassifierPageState extends State<CameraClassifierPage> {
  late DiseaseDetectionModel classifier;
  List<CameraDescription> cameras =[];
  late CameraController cameraController;

  @override
  void initState() {
    super.initState();
    classifier = DiseaseDetectionModel(numThreads: 1); // Instantiate your concrete subclass
    loadCamera();
  }

  Future<void> loadCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );
    await cameraController.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    classifier.close();
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _classifyImage(img.Image image) async {
    tflite_helper.Category prediction = classifier.predict(image);
    print('Predicted category: ${prediction.label}');
    // Display the prediction result in a dialog or any other UI element
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Prediction'),
          content: Text('Predicted category: ${prediction.label}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _captureImage() async {
    try {
      final image = await cameraController.takePicture();
      final File imageFile = File(image.path);
      final img.Image capturedImage = img.decodeImage(imageFile.readAsBytesSync())!;
      _classifyImage(capturedImage);
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<void> _selectImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final img.Image selectedImage = img.decodeImage(imageFile.readAsBytesSync())!;
      _classifyImage(selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Classifier'),
      ),
      body: CameraPreview(cameraController),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _captureImage,
            tooltip: 'Capture Image',
            child: Icon(Icons.camera_alt),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _selectImageFromGallery,
            tooltip: 'Select Image',
            child: Icon(Icons.photo_library),
          ),
        ],
      ),
    );
  }
}
