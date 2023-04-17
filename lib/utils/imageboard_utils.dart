import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  //create button parameters
  RawMaterialButton createButton(String name, String location, Color color) {
    RawMaterialButton button = RawMaterialButton(
      key: Key(name),
      onPressed: null,
      elevation: 2.0,

      shape: RoundedRectangleBorder(
          side: BorderSide(color: color, width: 2),
          borderRadius: BorderRadius.circular(18)),
      //fillColor: buttonColor,
      padding: const EdgeInsets.all(3.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: CachedNetworkImage(
            imageUrl: location,
            height: 100,
            width: 100,
            fit: BoxFit.contain,
          ),
        ),
        Column(
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        )
      ]),
    );
    return button;
  }

  RawMaterialButton createFolder(String name, Color color) {
    const folderIcon = Icon(Icons.folder);
    RawMaterialButton button = RawMaterialButton(
      key: Key(name),
      onPressed: () {},
      elevation: 2.0,

      shape: RoundedRectangleBorder(
          side: BorderSide(color: color, width: 2),
          borderRadius: BorderRadius.circular(18)),
      //fillColor: buttonColor,
      padding: const EdgeInsets.all(3.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Expanded(
          child: folderIcon,
        ),
        Column(
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        )
      ]),
    );
    return button;
  }

  Future<List<RawMaterialButton>> populateButtons() async {
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

      RawMaterialButton imageButton =
          createButton(buttonName, buttonLocation, buttonColor);
      buttons.add(imageButton);
    }

    //Iterate through each Folder in the UserID collection
    QuerySnapshot<Map<String, dynamic>> folderRef = await FirebaseFirestore
        .instance
        .collection('user-information')
        .doc(uid)
        .collection('folders')
        .get();

    for (var doc in folderRef.docs) {
      if (doc.id == 'initial') {
        continue;
      }

      for (var folderDoc in folderRef.docs) {
        //Create a RawMaterialButton for the folders

        int colorValue = folderDoc['folder_color'];
        String buttonName = folderDoc['folder_name'];
        Color buttonColor = Color(colorValue);

        RawMaterialButton folderButton = createFolder(buttonName, buttonColor);
        buttons.add(folderButton);

        //Iterate through each document in the current folder
        QuerySnapshot<Map<String, dynamic>> imageRef = await FirebaseFirestore
            .instance
            .collection('user-information')
            .doc(uid)
            .collection('folders')
            .doc(folderDoc.id)
            .collection('images')
            .get();

        for (var imageDoc in imageRef.docs) {
          //create a RawMaterialBUtton for the buttons within a folder

          int colorValue = imageDoc['image_color'];
          String buttonName = imageDoc['image_name'];
          String buttonLocation = imageDoc['image_location'];
          Color buttonColor = Color(colorValue);

          RawMaterialButton imageButton =
              createButton(buttonName, buttonLocation, buttonColor);
          buttons.add(imageButton);
        }
      }
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
