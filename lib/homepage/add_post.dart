import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _contentController = TextEditingController();
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  String _imageUrl = ''; // Store the URL of the uploaded image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter your post content...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _handleImagePick();
              },
              child: Text('Add Image'),
            ),
            SizedBox(height: 20),
            if (_imageUrl.isNotEmpty)
              Image.network(_imageUrl), // Display the uploaded image if available
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _createPost();
                  Navigator.pop(context); // Close the page after creating the post
                },
                child: Text('Post'),
              ),
            ),
          ],
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
        'comments': [], // Initialize comments as an empty list
      });
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
