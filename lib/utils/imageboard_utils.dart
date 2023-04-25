import 'dart:io';
import 'package:aacademic/utils/tts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class ImageboardUtils {
  File? _selectedImage;

  Future<File?> chooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      return _selectedImage;
    }
    return null;
  }

  Future<void> uploadImage(String name, Color buttonColor) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference imageboardRef;

    //if (isFolder = true) {
    //  await FirebaseFirestore.instance
    //  .collection('user-information')
    ///  .doc(uid)
    //  .collection('folders')
    //  .doc(folderName)
    //  .set({
    //    'folder_name': folderName,
    //    'folder_color': buttonColor,
    //  })
    //}

    //if (folderName == 'imageboard') {
    imageboardRef = FirebaseFirestore.instance
        .collection('user-information')
        .doc(uid)
        .collection('imageboard');
    //} else {
    //  imageboardRef = FirebaseFirestore.instance
    //      .collection('user-information')
    //     .doc(uid)
    //      .collection('folders')
    //      .doc(folderName)
    //      .collection('images');
    //}

    DocumentReference uploadedImage = imageboardRef.doc();
    String uploadedImageID = uploadedImage.id;

    final tempDir = await getTemporaryDirectory();
    final tempFilePath = '${tempDir.path}/image.jpg';

    //checks if image file is a jpeg
    if (!(_selectedImage!.path.endsWith('.jpeg') ||
        _selectedImage!.path.endsWith('.jpg'))) {
      //if not a jpeg, compress by 50% and convert image to jpeg
      print("NOT A JPEG");
      img.Image? image = img.decodeImage(_selectedImage!.readAsBytesSync());
      img.Image resizedImage = img.copyResize(image!, width: 500);
      final compressedImageBytes = img.encodeJpg(resizedImage, quality: 50);
      await File(tempFilePath).writeAsBytes(compressedImageBytes);

      //upload image to server
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(uid)
          .child(uploadedImageID);

      UploadTask uploadTask = firebaseStorageRef.putFile(File(tempFilePath));
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      final int buttonColorValue = buttonColor.value;

      //upload image to database
      await imageboardRef.add({
        'image_name': name,
        'image_location': imageUrl,
        'image_color': buttonColorValue,
      });

      print('Image uploaded to $imageUrl');
    } else {
      //if image is a jpeg, skip compression and conversion and continue as normal!!
      print("IS A JPEG");
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(uid)
          .child(uploadedImageID);

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

  RawMaterialButton createFolder(
      String name,
      Color color,
      String folderId,
      Map<String, List<RawMaterialButton>> folderButtonsMap,
      Function(List<RawMaterialButton>) onFolderSelect) {
    const folderIcon = Icon(Icons.folder, size: 48);
    RawMaterialButton button = RawMaterialButton(
      key: Key(name),
      onPressed: () {
        print(folderId);
        List<RawMaterialButton>? folderButtons = folderButtonsMap[folderId];
        print(folderButtons);
        onFolderSelect(folderButtons ?? []);
        TextToSpeech.speak(name);
      },
      elevation: 2.0,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: color, width: 2),
          borderRadius: BorderRadius.circular(18)),
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
