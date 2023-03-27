import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageboardUtils {
  static CollectionReference imageboardRef =
      FirebaseFirestore.instance.collection('user-information').doc(user.uid).collection('imageboard');
  static Reference storageRef =
      FirebaseStorage.instance.ref().child('users/$uid/');