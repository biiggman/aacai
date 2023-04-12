import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:aacademic/utils/tts.dart';

class ImageboardUtils {
  File? _selectedImage;

  Future<File?> chooseImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      return _selectedImage;
    }
    return null;
  }

  Future<void> uploadImage(String name, Color buttonColor) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference imageboardRef = FirebaseFirestore.instance
        .collection('user-information')
        .doc(uid)
        .collection('imageboard');

    DocumentReference uploadedImage = imageboardRef.doc();
    String uploadedImageID = uploadedImage.id;

    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('users/$uid/$uploadedImageID');
    UploadTask uploadTask = firebaseStorageRef.putFile(_selectedImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    final int buttonColorValue = buttonColor.value;

    await imageboardRef.add({
      'image_name': name,
      'image_location': imageUrl,
      'image_color': buttonColorValue,
    });

    print('Image uploaded to $imageUrl');
  }
}

class ButtonUtils {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<List<RawMaterialButton>> makeButtons() async {
    QuerySnapshot<Map<String, dynamic>> imageboardRef = await FirebaseFirestore
        .instance
        .collection('user-information')
        .doc(uid)
        .collection('imageboard')
        .orderBy('image_color', descending: true)
        .get();

    List<RawMaterialButton> buttons = [];

    for (var doc in imageboardRef.docs) {
      if (doc.id == 'initial') {
        continue;
      }

      //data from database
      int colorValue = doc['image_color'];
      String buttonName = doc['image_name'];
      String buttonLocation = doc['image_location'];
      Color buttonColor = Color(colorValue);

      //create button based on data above
      buttons.add(RawMaterialButton(
        key: Key(buttonName),
        onPressed: null,

        elevation: 2.0,

        //shape of button
        shape: RoundedRectangleBorder(
            side: BorderSide(color: buttonColor, width: 2),
            borderRadius: BorderRadius.circular(18)),
        //fillColor: buttonColor,
        padding: const EdgeInsets.all(3.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: buttonLocation,
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
          ),
          Column(
            children: [
              Text(
                buttonName,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          )
        ]),
      ));
    }
    return buttons;
  }

  List<RawMaterialButton> tappedButtons = [];
  List<String> tappedButtonNames = [];

  void addButtonToList(RawMaterialButton button) {
    //creates a copy of the button
    RawMaterialButton newButton = RawMaterialButton(
      onPressed: null,
      onLongPress: null,
      elevation: button.elevation,
      constraints: button.constraints,
      shape: button.shape,
      padding: button.padding,
      child: button.child,
    );

    //extracts name of the button
    String buttonName = button.key
        .toString()
        .replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll("'", '');

    //adds button copy object and the name of the button to respected lists
    tappedButtons.add(newButton);
    tappedButtonNames.add(buttonName);

    //debug test to see if working
    print(buttonName);
  }
}
