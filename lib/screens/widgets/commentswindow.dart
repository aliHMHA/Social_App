import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/comment_model.dart';
import 'package:flutter_complete_guide/providers/chatANDuploadController.dart';
import 'package:intl/intl.dart';

class CommentsWindow extends StatelessWidget {
  final Comment comment;

  CommentsWindow({required this.comment});

  @override
  Widget build(BuildContext context) {
    DateTime puplishdate = comment.timedate.toDate();

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              backgroundImage: NetworkImage(comment.commenterimage),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.commentername),
                Text(
                  DateFormat.yMMMd().format(puplishdate),
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            Expanded(
              child: SizedBox(),
            ),
            Column(
              children: [
                IconButton(
                    onPressed: () {
                      ChatAndUploadController().likecomment(
                          uid: FirebaseAuth.instance.currentUser!.uid,
                          postid: comment.postid,
                          likes: comment.likes,
                          commentid: comment.commentid,
                          commentownerid: comment.useridd);
                    },
                    icon: comment.likes
                            .contains(FirebaseAuth.instance.currentUser!.uid)
                        ? Icon(Icons.favorite, color: Colors.red)
                        : Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                          )),
                Text('${comment.likes.length} likes')
              ],
            )
          ]),
          Container(
            padding: EdgeInsets.only(left: 30, right: 50),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.all(8),
              child: Text(
                comment.commentText,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
