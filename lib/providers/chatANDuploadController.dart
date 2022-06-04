import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/mesage_model.dart';
import 'package:image_picker/image_picker.dart';

class ChatAndUploadController {
  // List<SocialUser> _allUsers = [];
  // SocialUser? _userdata;
  // List<MessageModel> _messagelist = [];

  // List<SocialUser> get alluserslist {
  //   List<SocialUser> hh = _allUsers;
  //   return hh;
  // }

  // List<MessageModel> get messagelist {
  //   List<MessageModel> ggtt = _messagelist;
  //   return ggtt;
  // }

  // set currentuser(SocialUser gggg) {
  //   _userdata = gggg;
  // }

  // Future<void> getAllUsers() {
  //   return FirebaseFirestore.instance.collection('users').get().then((value) {
  //     _allUsers.clear();
  //     value.docs.forEach((element) {
  //       SocialUser ff = SocialUser.fromJeson(element.data());
  //       if (ff.uid != _userdata!.uid) {
  //         _allUsers.add(ff);
  //       }
  //     });
  //   });
  // }

  // void getallmessages(String chatterid) {
  //   _messagelist.clear();
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_userdata!.uid)
  //       .collection('chats')
  //       .doc(chatterid)
  //       .collection('messages')
  //       .orderBy('timeDate')
  //       .snapshots()
  //       .listen((event) {
  //     _messagelist = [];
  //     event.docs.forEach((element) {
  //       _messagelist.add(MessageModel.fromJeson(element.data()));
  //     });
  //     notifyListeners();
  //   });
  // }

  void sendamesageto(MessageModel message) async {
    List<MessageModel> _messagelist = [];
    CollectionReference fff = FirebaseFirestore.instance.collection('users');

    fff
        .doc(message.userid)
        .collection('chats')
        .doc(message.reseverid)
        .collection('messages')
        .add(message.tomap())
        .then((value) {
      fff
          .doc(message.reseverid)
          .collection('chats')
          .doc(message.userid)
          .collection('messages')
          .add(message.tomap());
    }).then((value) {
      fff
          .doc(message.userid)
          .collection('chats')
          .doc(message.reseverid)
          .collection('messages')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          _messagelist.add(MessageModel.fromJeson(element.data()));
        });
      });
    }).then((value) {});
  }

  Future<void> likecomment(
      {required String uid,
      required String postid,
      required List likes,
      required String commentid,
      required String commentownerid}) async {
    final _firestore = FirebaseFirestore.instance;
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postid)
            .collection('comments')
            .doc(commentid)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(commentownerid).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postid)
            .collection('comments')
            .doc(commentid)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(commentownerid).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> uploadMethod(
      {required String uidsubfolder,
      required String firstfolder,
      required File file,
      required bool ispost,
      required postidOrimagname}) async {
    Reference reff =
        FirebaseStorage.instance.ref().child(firstfolder).child(uidsubfolder);

    if (ispost) {
      reff = reff.child(postidOrimagname);
    }

    UploadTask up = reff.putFile(file);
    TaskSnapshot snap = await up;
    String downloadurl = await snap.ref.getDownloadURL();
    return downloadurl;
  }

  imagepicker(ImageSource imageee, BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    XFile? image = await _picker.pickImage(source: imageee);

    if (image != null) {
      return image;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('no image was selected')));
    }
  }

  Future<File?> showdialogforimagepick(
      {required BuildContext context, required Size media}) async {
    File? image;

    XFile? ggh;

    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              title: const Text('Select image'),
              content: Container(
                padding: const EdgeInsets.only(top: 10),
                width: media.width * .5,
                height: media.height * .25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        ggh = await imagepicker(ImageSource.gallery, context);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 50),
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        height: media.height * .1,
                        child: const Text('From gallary',
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        ggh = await imagepicker(ImageSource.camera, context);

                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 50),
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        height: media.height * .1,
                        child: const Text('From camera',
                            style: TextStyle(fontSize: 20)),
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 161, 95, 172),
                      ),
                    ))
              ],
            ));
    if (ggh == null) {
      return image;
    } else {
      image = File(ggh!.path);
      return image;
    }
  }

  showsnackbarr(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
