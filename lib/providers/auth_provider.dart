import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_complete_guide/models/user_model.dart';

class Authprovider with ChangeNotifier {
  SocialUser? _userr;

  SocialUser get getdattttta => _userr!;

  Future<void> getdata() async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      var userinfo =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      SocialUser gg = SocialUser.fromsnap(userinfo);
      _userr = gg;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // Future<void> condition() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     if (prefs.containsKey('userdata')) {
  //       _userData =
  //           json.decode(prefs.getString('userdata')) as Map<String, Object>;
  //       print(_userData['userid']);
  //       await FirebaseAuth.instance
  //           .signInWithEmailAndPassword(
  //               email: _userData['email'], password: _userData['password'])
  //           .then((value) {
  //         _token = value.user.getIdToken();
  //         notifyListeners();
  //       });
  //     } else {
  //       return;
  //     }
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

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
      String? _profileurl;
      String? _coverurl;
      await FirebaseStorage.instance
          .ref()
          .child("users/${Uri.file(profilepic.path).pathSegments.last}")
          .putFile(profilepic)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          _profileurl = value;
        });
      });
      await FirebaseStorage.instance
          .ref()
          .child("users/${Uri.file(profilepic.path).pathSegments.last}")
          .putFile(coverimage)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          _coverurl = value;
        });
      });

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        SocialUser model = SocialUser(
          followers: [],
          following: [],
          comments: [],
          posts: [],
          likes: [],
          email: email,
          uid: value.user!.uid,
          imageURL: _profileurl!,
          coverURL: _coverurl!,
          bio: bio,
          phone: phone,
          name: name,
        );

        FirebaseFirestore.instance
            .collection('users')
            .doc(model.uid)
            .set(model.tomap());
      });

      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString('userdata', jsonEncode(_userData));
    } catch (error) {
      print(error.toString());
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

      // var prefs = await SharedPreferences.getInstance();
      // prefs.setString('userdata', jsonEncode(_userData));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
