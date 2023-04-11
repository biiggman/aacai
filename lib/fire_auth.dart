import 'package:firebase_auth/firebase_auth.dart';
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
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId:
              "1062028064938-e4inidfj0v6eho6mm7r4n4u6qa4m821f.apps.googleusercontent.com");

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
        content,
        style:
            TextStyle(color: Color.fromARGB(255, 1, 4, 0), letterSpacing: 0.5),
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
