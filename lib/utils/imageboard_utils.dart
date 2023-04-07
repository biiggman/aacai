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
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      return _selectedImage;
    }
    return null;
  }

  //THIS IS FOR TRYING TO LIST ASSET IMAGES AS SELECTABLE (SIMILAR TO PHOTO GALLERY)
  //MIGHT DELETE LOL
  //Future<List<String>> loadAssetImages() async {
  //  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  //  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  //  final imagePaths = manifestMap.keys
  //      .where((String key) => key.contains('assets/images/'))
  //      .toList();

  //  return imagePaths;
  //}

  Future<void> uploadImage(String name, String size, Color buttonColor) async {
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
      'image_size': size,
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
        .orderBy(FieldPath.documentId)
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
      String buttonSize = doc['image_size'];
      Color buttonColor = Color(colorValue);

      double baseSize = 100.0;
      int numberSize = int.parse(buttonSize);

      //create button based on data above
      buttons.add(RawMaterialButton(
        key: Key(buttonName),
        onPressed: null,

        //size of button (NOT FUNCTIONAL)
        elevation: 2.0,
        constraints: BoxConstraints(
          minHeight: baseSize * numberSize,
          minWidth: baseSize * numberSize,
        ),

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
    RawMaterialButton newButton = RawMaterialButton(
      onPressed: null,
      onLongPress: null,
      elevation: button.elevation,
      constraints: button.constraints,
      shape: button.shape,
      padding: button.padding,
      child: button.child,
    );
    String buttonName = button.key
        .toString()
        .replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll("'", '');
    tappedButtons.add(newButton);
    tappedButtonNames.add(buttonName);
    print(buttonName);
  }

  List<RawMaterialButton> setButtonList(List<RawMaterialButton> buttonList) {
    buttonList = tappedButtons;
    print("SET LIST");
    return buttonList;
  }

  List<String> setNameList(List<String> nameList) {
    nameList = tappedButtonNames;
    return nameList;
  }
}
