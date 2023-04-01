import 'dart:io';
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

      int colorValue = doc['image_color'];
      String buttonName = doc['image_name'];
      String buttonLocation = doc['image_location'];
      String buttonSize = doc['image_size'];
      Color buttonColor = Color(colorValue);

      List<int> sizeParts = buttonSize.split('x').map(int.parse).toList();
      double baseSize = 100.0;
      double scaleX = sizeParts[0].toDouble();
      double scaleY = sizeParts.length > 1 ? sizeParts[1].toDouble() : scaleX;

      buttons.add(RawMaterialButton(
        onPressed: () {
          TextToSpeech.speak(buttonName);
        },
        onLongPress: () {

          //ADD EDIT MENU HERE???
          //          
          //showDialog(
          //  context: context,
          //  builder: (BuildContext context) {
          //    return AlertDialog(
          //      scrollable: true,
          //      title: Text("Edit $buttonName"),
          //      content: Padding(
          //        padding: const EdgeInsets.all(10.0),
          //        child: Form(
          //          child: Row(
          //            crossAxisAlignment: CrossAxisAlignment.center,
          //            children: [
          //             Expanded(
          //                flex: 4,
          //                child: 
          //              )
          //            ],
          //          ),))
          //    );
          //    
          //  }
        //  );
        },
        elevation: 0.0,
        constraints: BoxConstraints(
            minHeight: baseSize * scaleY, 
            minWidth: baseSize * scaleX,
        ),
        
        shape: RoundedRectangleBorder(
            side: BorderSide(color: buttonColor, width: 2),
            borderRadius: BorderRadius.circular(18)),
        fillColor: buttonColor,
        padding: const EdgeInsets.all(3.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.network(
            buttonLocation,
            height: 125,
            width: 125,
            fit: BoxFit.cover,
          ),
        ]),
      ));
    }
    return buttons;
  }

  //Future<void> deleteImage
}
