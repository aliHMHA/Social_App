import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Postinfo {
  String uid;
  String name;
  String imageURL;
  String postText;
  String? postImage;
  String timeDate;
  List likes;
  List commentsnum;
  String postid;

  Postinfo(
      {required this.uid,
      required this.imageURL,
      required this.name,
      required this.postText,
      this.postImage,
      required this.timeDate,
      required this.likes,
      required this.commentsnum,
      required this.postid});

  static Postinfo fromJeson(Map<String, dynamic> json) {
    return Postinfo(
      uid: json['uid'],
      imageURL: json['imageURL'],
      name: json['name'],
      postImage: json['postImage'],
      postText: json['postText'],
      timeDate: json['timeDate'],
      likes: json['likes'],
      postid: json['postid'],
      commentsnum: json['commentsnum'],
    );
  }

  static Postinfo fromsnap(DocumentSnapshot snap) {
    final json = snap.data() as Map<String, dynamic>;
    return Postinfo(
      uid: json['uid'],
      imageURL: json['imageURL'],
      name: json['name'],
      postImage: json['postImage'],
      postText: json['postText'],
      timeDate: json['timeDate'],
      likes: json['likes'],
      postid: json['postid'],
      commentsnum: json['commentsnum'],
    );
  }

  Map<String, dynamic> tomap() {
    return {
      'uid': uid,
      'imageURL': imageURL,
      'name': name,
      'postImage': postImage,
      'postText': postText,
      'timeDate': timeDate,
      'likes': likes,
      'postid': postid,
      'commentsnum': commentsnum
    };
  }
}
