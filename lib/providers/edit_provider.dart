import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_complete_guide/models/user_model.dart';

class EditProvider with ChangeNotifier {
  String? _profileurl;
  String? _coverUrl;

  Future<void> edite(
      {String? phone,
      String? name,
      String? bio,
      required SocialUser user,
      required BuildContext context}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'imageURL': _profileurl ?? user.imageURL,
        'coverURL': _coverUrl ?? user.coverURL,
        'name': name ?? user.name,
        'phone': phone ?? user.phone,
        'bio': bio ?? user.bio,
      });
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> uploadProfilImage(
      File imagetoupload, BuildContext context) async {
    try {
      await FirebaseStorage.instance
          .ref()
          .child("users/${Uri.file(imagetoupload.path).pathSegments.last}")
          .putFile(imagetoupload)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          _profileurl = value;
        });
      }).catchError((error) {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> uploadCoverImage(
      File imagetoupload, BuildContext context) async {
    try {
      await FirebaseStorage.instance
          .ref()
          .child("users/${Uri.file(imagetoupload.path).pathSegments.last}")
          .putFile(imagetoupload)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          _coverUrl = value;
        }).catchError((error) {});
      }).catchError((error) {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
