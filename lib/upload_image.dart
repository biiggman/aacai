import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class UploadImage extends StatefulWidget {
  const UploadImage ({super.key});
  
  @override
  State<UploadImage> createState() => _UploadImageState();
}


class _UploadImageState extends State<UploadImage> {
  File? _imageFile = null;

  final picker = ImagePicker();

  Future<void> chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
      _imageFile = File(pickedFile.path);
    });
    }
  }

  Future<void> uploadImage() async {

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select an image to upload.'),
      ));
      return;
    }

    String fileName = Path.basename(_imageFile!.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Upload Image"),
      ),
    body: Center (
      child: _imageFile == null
    ? Text("No image selected.")
    : Image.file(_imageFile!),
    ),
    floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: chooseImage,
          tooltip: "Pick Image",
          child: Icon(Icons.add_a_photo),
          ),
          SizedBox(height:16),
          FloatingActionButton(
            onPressed: uploadImage,
            tooltip: "Upload Image",
            child: Icon(Icons.cloud_upload),)],),);
  }
}