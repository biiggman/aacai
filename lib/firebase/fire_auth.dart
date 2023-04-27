import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class FireAuth {
  // For registering a new user
  static Future<User?> registerUsingEmailPassword(
      {required String name,
      required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;

      // Create user document with imageboard subcollection upon user creation
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('user-information');
      await userCollection.doc(user!.uid).set({
        'username': name,
        'email': email,
      });
      CollectionReference imageboardCollection =
          userCollection.doc(user.uid).collection('imageboard');

      DocumentReference initialDocument = imageboardCollection.doc('initial');

      //set default values for initial value NOTE: Firebase Firestore requires a document to be present to create a subfolder. pain :/

      await initialDocument.set({
        'image_color': '0xff000000',
        'image_name': 'Initial',
        'image_location': 'example.com/pleaseGiveMeAGoodGradeDrIslam',
        'image_size': '1x1',
      });

      CollectionReference folderCollection =
          userCollection.doc(user.uid).collection('folders');

      DocumentReference initialFolder = folderCollection.doc('initial');
      await initialFolder.set({
        'folderName': 'TEST',
      });

      // create a folder in Cloud Storage upon user creation
      final storageRef =
          FirebaseStorage.instance.ref().child('users/${user.uid}');
      final ByteData blankFileData =
          await rootBundle.load('assets/welcome.txt');
      final Uint8List blankFileBytes = blankFileData.buffer.asUint8List();
      await storageRef.child('welcome.txt').putData(blankFileBytes);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          FireAuth.customSnackBar(
            content: 'The password provided is too weak',
            color: Colors.red,
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          FireAuth.customSnackBar(
            content: 'Account already exists for that email',
            color: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  // For signing in a user (have already registered)
  static Future<User?> signInUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          FireAuth.customSnackBar(
            content: 'No account found for that email',
            color: Colors.red,
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          FireAuth.customSnackBar(
            content: 'Incorrect password provided',
            color: Colors.red,
          ),
        );
      }
    }

    return user;
  }

  //Refresh user
  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  //google login
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;

        // Create user document with imageboard and folder subcollection upon user creation
        CollectionReference userCollection =
            FirebaseFirestore.instance.collection('user-information');
        DocumentSnapshot userDocument =
            await userCollection.doc(user!.uid).get();

        if (userDocument.exists) {
          //User already exists
          print("User already exists in Firestore");
        } else {
          //User does not exist, create respected documents in Firestore

          await userCollection.doc(user.uid).set({
            'username': user.displayName,
            'email': user.email,
          });

          CollectionReference imageboardCollection =
              userCollection.doc(user.uid).collection('imageboard');

          DocumentReference initialDocument =
              imageboardCollection.doc('initial');
          await initialDocument.set({
            'image_color': '0xff000000',
            'image_name': 'Initial',
            'image_location': 'example.com/pleaseGiveMeAGoodGradeDrIslam',
            'image_size': '1x1',
          });

          CollectionReference folderCollection =
              userCollection.doc(user.uid).collection('folders');

          DocumentReference initialFolder = folderCollection.doc('initial');
          await initialFolder.set({
            'folderName': 'TEST',
          });

          // create a folder in Cloud Storage upon user creation
          final storageRef =
              FirebaseStorage.instance.ref().child('users/${user.uid}');
          final ByteData blankFileData =
              await rootBundle.load('assets/welcome.txt');
          final Uint8List blankFileBytes = blankFileData.buffer.asUint8List();
          await storageRef.child('welcome.txt').putData(blankFileBytes);
          print("Complete");
        }
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId: Platform.isAndroid
              //android client ID
              ? "1062028064938-ltcfikbalg14ann9q6mtjv5281uasp57.apps.googleusercontent.com"
              //ios client ID
              : "1062028064938-e4inidfj0v6eho6mm7r4n4u6qa4m821f.apps.googleusercontent.com");

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;

          // Create user document with imageboard subcollection upon user creation
          CollectionReference userCollection =
              FirebaseFirestore.instance.collection('user-information');
          DocumentSnapshot userDocument =
              await userCollection.doc(user!.uid).get();

          if (userDocument.exists) {
            //User already exists
            print("User already exists in Firestore");
          } else {
            //User does not exist, create respected documents in Firestore

            await userCollection.doc(user.uid).set({
              'username': user.displayName,
              'email': user.email,
            });

            CollectionReference imageboardCollection =
                userCollection.doc(user.uid).collection('imageboard');

            DocumentReference initialDocument =
                imageboardCollection.doc('initial');
            await initialDocument.set({
              'image_color': '0xff000000',
              'image_name': 'Initial',
              'image_location': 'example.com/pleaseGiveMeAGoodGradeDrIslam',
              'image_size': '1x1',
            });

            CollectionReference folderCollection =
                userCollection.doc(user.uid).collection('folders');

            DocumentReference initialFolder = folderCollection.doc('initial');
            await initialFolder.set({
              'folderName': 'TEST',
            });

            // create a folder in Cloud Storage upon user creation
            final storageRef =
                FirebaseStorage.instance.ref().child('users/${user.uid}');
            final ByteData blankFileData =
                await rootBundle.load('assets/welcome.txt');
            final Uint8List blankFileBytes = blankFileData.buffer.asUint8List();
            await storageRef.child('welcome.txt').putData(blankFileBytes);
            print("Complete");
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              FireAuth.customSnackBar(
                content:
                    'An account already exists with a different credential',
                color: Colors.red,
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              FireAuth.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
                color: Colors.red,
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            FireAuth.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
              color: Colors.red,
            ),
          );
        }
      }
    }
    return user;
  }

  //google sign out
  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        FireAuth.customSnackBar(
          content: 'Error signing out. Try again.',
          color: Colors.red,
        ),
      );
    }
  }

  //snackbar to handle authorization errors
  static SnackBar customSnackBar({required String content, required color}) {
    return SnackBar(
      backgroundColor: color,
      content: Text(
        textAlign: TextAlign.center,
        content,
        style: const TextStyle(
            color: Color.fromARGB(255, 1, 4, 0),
            letterSpacing: 0.5,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  //forgot password
  static Future<void> forgotPassword(
      {required String email, required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        FireAuth.customSnackBar(
          content: 'Password reset email sent',
          color: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(FireAuth.customSnackBar(
          content: 'No account found for that email',
          color: Colors.red,
        ));
      }
    }
  }
}
