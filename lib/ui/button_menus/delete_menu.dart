import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aacademic/utils/UI_templates.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../firebase/fire_auth.dart';

class DeleteMenu extends StatefulWidget {
  final bool isFolder;
  final String? id;
  final String? folderID;

  const DeleteMenu({super.key, required this.isFolder, this.id, this.folderID});
  @override
  _DeleteMenuState createState() => _DeleteMenuState();
}

class _DeleteMenuState extends State<DeleteMenu> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> deleteButton() async {
    if (widget.isFolder == true) {
      print('IS A FOLDER');

      //deletes folder itself
      await FirebaseFirestore.instance
          .collection('user-information')
          .doc(uid)
          .collection('folders')
          .doc(widget.folderID)
          .delete();

      //delete 'images' subcollection files
      await FirebaseFirestore.instance
          .collection('user-information')
          .doc(uid)
          .collection('folders')
          .doc(widget.folderID)
          .collection('images')
          .get()
          .then((QuerySnapshot) {
        for (var DocumentSnapshot in QuerySnapshot.docs) {
          DocumentSnapshot.reference.delete();
        }
      });
    }
    if (widget.isFolder == false && widget.folderID != "") {
      print('IN A FOLDER');
      print(widget.folderID);
      print(widget.id);
      await FirebaseFirestore.instance
          .collection('user-information')
          .doc(uid)
          .collection('folders')
          .doc(widget.folderID)
          .collection('images')
          .doc(widget.id)
          .delete();
    }
    if (widget.isFolder == false && widget.folderID == "") {
      print('ON IMAGEBOARD');
      await FirebaseFirestore.instance
          .collection('user-information')
          .doc(uid)
          .collection('imageboard')
          .doc(widget.id)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('del_menu_prompt'.tr()),
      content: Text('del_menu_warning'.tr()),
      actions: <Widget>[
        TextButton(
          child: Text('del_menu_cancel_btn'.tr()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('del_menu_accept_btn'.tr()),
          onPressed: () {
            deleteButton();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(FireAuth.customSnackBar(
              content: widget.isFolder == true
                  ? 'del_menu_folder_delete'.tr()
                  : 'del_menu_button_delete'.tr(),
              color: Colors.green,
            ));
          },
        ),
      ],
    );
  }
}
