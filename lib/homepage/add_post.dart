import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../constant_colors.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _contentController = TextEditingController();
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  File? _image;
  String _imageUrl = '';
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Post',
          style: TextStyle(
            color: AppColors.primaryColor,
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor2,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.secondaryColor,
                  hintText: 'Enter your post content...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  await _handleImagePick();
                },
                icon: const Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: Colors.black54,
                ),
                label: Text(
                  'Add Image',
                  style: TextStyle(
                    color: AppColors.textColorLight,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                ),
              ),
              const SizedBox(height: 20),
              if (_imageUrl.isNotEmpty)
                Image.network(
                  _imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                ), // Display the uploaded image if available
              const Spacer(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _createPost();
                    Navigator.pop(context); // Close the page after creating the post
                  },
                  icon: const Icon(
                    Icons.arrow_upward,
                    size: 30,
                    color: Colors.black54,
                  ),
                  label: Text(
                    'Post',
                    style: TextStyle(
                      color: AppColors.textColorLight,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleImagePick() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = await pickedFile.readAsBytes();
      final TaskSnapshot uploadSnapshot = await _storage.ref().child('images/${DateTime.now()}.jpg').putData(imageFile);
      final downloadUrl = await uploadSnapshot.ref.getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl;
      });
    }
  }

  Future<void> _createPost() async {
    final content = _contentController.text.trim();
    if (content.isNotEmpty) {
      await _firestore.collection('Posts').doc().set({
        'content': content,
        'imageUrl': _imageUrl,
        'timestamp': Timestamp.now(),
        'comments': [],
        'posterUid' : FirebaseAuth.instance.currentUser?.uid
      });
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
