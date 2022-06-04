import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/comment_model.dart';
import 'package:flutter_complete_guide/models/user_model.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_complete_guide/models/post_model.dart';
import 'package:uuid/uuid.dart';

import '../models/share_model.dart';

class PostProvider with ChangeNotifier {
  late String _postimageUrl;

  // bool isloading;
  SocialUser? _userdata;
  set userinfo(SocialUser value) {
    _userdata = value;
  }

  List<Postinfo> _postsinfolist = [];

  List<String> _postidlist = [];

  List<int> _likes = [];
  List<int> _commentnumberlist = [];

  List<int> get likeslist {
    List<int> comment = _likes;
    return comment;
  }

  List<int> get comentnumberlist {
    List<int> comment = _commentnumberlist;
    return comment;
  }

  List _comments = [];

  List<String> get postidlist {
    List<String> dsadasdasd;
    dsadasdasd = _postidlist;
    return dsadasdasd;
  }

  List get comments {
    List dd = _comments;
    return dd;
  }

  List<Postinfo> get postlistsss {
    List<Postinfo> dsdgr;
    dsdgr = _postsinfolist;
    return dsdgr;
  }

  Future<void> creatpostwithimage(
      String posttexttt, File imagetoupload, String userid) async {
    final imageid = Uuid().v1();
    await FirebaseStorage.instance
        .ref()
        .child("posts")
        .child(userid)
        .child(imageid)
        .putFile(imagetoupload)
        .then((value) {
      value.ref.getDownloadURL().then(
        (value) {
          _postimageUrl = value;
          createpost(
            posttexttt,
            _postimageUrl,
          );
        },
      ).catchError((error) {});
    }).catchError((error) {});
  }

  Future<void> createpost(String posttext, String? postimage) async {
    try {
      final postid = const Uuid().v1();

      Postinfo model = Postinfo(
          commentsnum: [],
          uid: _userdata!.uid,
          imageURL: _userdata!.imageURL,
          name: _userdata!.name,
          postText: posttext,
          timeDate: DateFormat.yMMMMd().format(DateTime.now()),
          postImage: postimage,
          likes: [],
          postid: postid);

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postid)
          .set(
            model.tomap(),
          )
          .catchError((error) {});
      await _firestore.collection('users').doc(_userdata!.uid).update({
        'posts': FieldValue.arrayUnion([postid])
      });
    } catch (err) {
      print(err);
    }
  }

  Future<void> share(
      {required String reciverid,
      required String postid,
      required String message,
      required String sendername,
      required String senderimageurl,
      required BuildContext context}) async {
    String shareid = const Uuid().v1();
    Timestamp time = Timestamp.fromDate(DateTime.now());
    String senderid = FirebaseAuth.instance.currentUser!.uid;
    Sharemodel share = Sharemodel(
        postid: postid,
        timedate: time,
        reciverid: reciverid,
        senderid: senderid,
        shareid: shareid,
        message: message,
        senderimageurl: senderimageurl,
        sendername: sendername);
    try {
      await _firestore
          .collection('users')
          .doc(reciverid)
          .collection('share')
          .doc(shareid)
          .set(share.tomap());

      await _firestore.collection('users').doc(reciverid).update({
        'sharesrecived': FieldValue.arrayUnion([shareid])
      });

      await _firestore
          .collection('users')
          .doc(senderid)
          .collection('share')
          .doc(shareid)
          .set(share.tomap());

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(' Post shared successfuly')));
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  final _firestore = FirebaseFirestore.instance;
  Future<void> likepost(
      {required String postid,
      required String userid,
      required List likes,
      required String postownerid,
      required BuildContext context}) async {
    try {
      if (likes.contains(userid)) {
        await _firestore.collection('posts').doc(postid).update({
          'likes': FieldValue.arrayRemove([userid])
        });
        await _firestore.collection('users').doc(postownerid).update({
          'likes': FieldValue.arrayRemove([userid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postid)
            .update({
          'likes': FieldValue.arrayUnion([userid])
        });
        await _firestore.collection('users').doc(postownerid).update({
          'likes': FieldValue.arrayUnion([userid])
        });
      }
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  Future<void> commentpost(Comment comment, BuildContext context) async {
    try {
      final ref = _firestore.collection('posts').doc(comment.postid);
      await ref
          .collection('comments')
          .doc(comment.commentid)
          .set(comment.tomap());

      await ref.update({
        'commentsnum': FieldValue.arrayUnion([comment.commentid])
      });
      await _firestore.collection('users').doc(_userdata!.uid).update({
        'comments': FieldValue.arrayUnion([comment.commentid])
      });
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }
}
