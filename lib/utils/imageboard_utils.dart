import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageboardUtils {
  File? _selectedImage;
  //static CollectionReference imageboardRef =
  //    FirebaseFirestore.instance.collection('user-information').doc(user.uid).collection('imageboard');
  //static Reference storageRef =
  //    FirebaseStorage.instance.ref().child('users/$uid/');

  Future<File?> chooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      return _selectedImage;
    }
    return null;
  }

  Future<List<String>> loadAssetImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/images/'))
        .toList();

    return imagePaths;
  }

  Future<void> uploadImage(String name, Color buttonColor) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference imageboardRef = FirebaseFirestore.instance
        .collection('user-information')
        .doc(uid)
        .collection('imageboard');

    DocumentReference uploadedImage = imageboardRef.doc();
    String uploadedImageID = uploadedImage.id;

    String documentID = imageboardRef.id;

    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('users/$uid/$uploadedImageID');
    UploadTask uploadTask = firebaseStorageRef.putFile(_selectedImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    String buttonColorName = buttonColor.toString();

    await imageboardRef.add({
      'image_name': name,
      'image_location': imageUrl,
      'image_color': buttonColorName,
    });

    print('Image uploaded to $imageUrl');
  }

  //Color convertColor() {

  //  String colorString = "MaterialColor(primary value: Color(0xffffeb3b))"; 
  //  String valueString = colorString.split('(0x')[1].split(')')[0];
  //  int colorValue = int.parse(valueString, radix: 16);
  //  Color otherColor = Color(colorValue);

    
  //}
}
