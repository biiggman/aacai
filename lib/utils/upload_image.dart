import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploader {
  final picker = ImagePicker();

  Future<String?> chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      return imageFile.path;
    }
    return null;
  }


Future<void> uploadImage(File imageFile, String fileName) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('users/$uid/$fileName');
  UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
  TaskSnapshot taskSnapshot = await uploadTask;
  String imageUrl = await taskSnapshot.ref.getDownloadURL();

  CollectionReference imageboardRef = FirebaseFirestore.instance
      .collection('user-information')
      .doc(uid)
      .collection('imageboard');

  await imageboardRef.add({
    'name': fileName,
    'location': imageUrl,
  });

  print('Image uploaded to $imageUrl');
}
}