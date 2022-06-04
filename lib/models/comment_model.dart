import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comment {
  String useridd;
  String postid;
  Timestamp timedate;
  String commentText;
  String commenterimage;
  List likes;
  String commentername;
  String commentid;

  Comment(
      {required this.commentText,
      required this.timedate,
      required this.postid,
      required this.useridd,
      required this.commenterimage,
      required this.likes,
      required this.commentername,
      required this.commentid});

  static Comment fromjson(Map<String, dynamic> json) {
    return Comment(
        useridd: json['userid'],
        timedate: json['timedate'],
        commentText: json['commenttext'],
        postid: json['postid'],
        commenterimage: json['commenterimage'],
        likes: json['likes'],
        commentername: json['commentername'],
        commentid: json['commentid']);
  }

  static Comment fromsnap(DocumentSnapshot snap) {
    final json = snap.data() as Map<String, dynamic>;
    return Comment(
      useridd: json['userid'],
      timedate: json['timedate'],
      commentText: json['commenttext'],
      postid: json['postid'],
      commenterimage: json['commenterimage'],
      likes: json['likes'],
      commentername: json['commentername'],
      commentid: json['commentid'],
    );
  }

  Map<String, dynamic> tomap() {
    return {
      'userid': useridd,
      'timedate': timedate,
      'commenttext': commentText,
      'postid': postid,
      'commenterimage': commenterimage,
      'likes': likes,
      'commentername': commentername,
      'commentid': commentid
    };
  }
}
