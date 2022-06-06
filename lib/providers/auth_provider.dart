import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_complete_guide/models/user_model.dart';

class Authprovider with ChangeNotifier {
  SocialUser? _userr;

  SocialUser get getdattttta => _userr!;

  set socialuserset(SocialUser value) {
    _userr = value;
  }

  Future<void> regester(
      {required BuildContext context,
      required String email,
      required String password,
      required String phone,
      required String name,
      required File profilepic,
      required String bio,
      required File coverimage}) async {
    try {
      final fireauth = FirebaseAuth.instance;

      String _profileurl;
      String _coverurl;
      final ref = FirebaseStorage.instance
          .ref()
          .child("users/${Uri.file(profilepic.path).pathSegments.last}");
      UploadTask upload = ref.putFile(profilepic);

      TaskSnapshot task = await upload;

      _profileurl = await task.ref.getDownloadURL();
      final refcover = FirebaseStorage.instance
          .ref()
          .child("users/${Uri.file(coverimage.path).pathSegments.last}");
      UploadTask uploadcover = refcover.putFile(coverimage);

      TaskSnapshot taskcover = await uploadcover;

      _coverurl = await taskcover.ref.getDownloadURL();

      final cred = await fireauth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      SocialUser model = SocialUser(
        sharesrecived: [],
        followers: [],
        following: [],
        comments: [],
        posts: [],
        likes: [],
        email: email,
        uid: cred.user!.uid,
        imageURL: _profileurl,
        coverURL: _coverurl,
        bio: bio,
        phone: phone,
        name: name,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(model.uid)
          .set(model.tomap());
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> signin(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
