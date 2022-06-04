import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_complete_guide/models/user_model.dart';

class EditProvider with ChangeNotifier {
  String? _profileurl;
  String? _coverUrl;
  late SocialUser _data;

  set tttrrrrr(SocialUser value) {
    _data = value;
  }

  Future<void> edite(String? phone, String? name, String? bio) async {
    SocialUser modde = SocialUser(
        email: _data.email,
        uid: _data.uid,
        phone: phone ?? _data.phone,
        bio: bio ?? _data.bio,
        imageURL: _profileurl ?? _data.imageURL,
        coverURL: _coverUrl ?? _data.coverURL,
        name: name ?? _data.name);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_data.uid)
          .update(modde.tomap());
    } catch (error) {}
  }

  Future<void> uploadProfilImage(File imagetoupload) async {
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
      throw (e);
    }
  }

  Future<void> uploadCoverImage(File imagetoupload) async {
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
      throw (e);
    }
  }
}
