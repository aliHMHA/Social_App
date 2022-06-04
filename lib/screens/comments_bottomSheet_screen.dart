import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/comment_model.dart';
import 'package:flutter_complete_guide/screens/widgets/commentswindow.dart';
import 'package:flutter_complete_guide/providers/post_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/auth_provider.dart';

class CommentBottomSeetScreen extends StatefulWidget {
  final String postid;

  CommentBottomSeetScreen({required this.postid});

  @override
  _CommentBottomSeetScreenState createState() =>
      _CommentBottomSeetScreenState();
}

class _CommentBottomSeetScreenState extends State<CommentBottomSeetScreen> {
  final TextEditingController commentcontoller = TextEditingController();

  bool _isloaging = true;
  List<Comment> _commentList = [];
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _commenttstream;

  @override
  void initState() {
    super.initState();
    commentStream();
  }

  commentStream() {
    _commentList.clear();
    _commenttstream = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postid)
        .collection('comments')
        .orderBy('timedate', descending: true)
        .snapshots()
        .listen((event) {
      _commentList = [];
      for (var element in event.docs) {
        _commentList.add(Comment.fromjson(element.data()));
      }
      setState(() {});
    });
    setState(() {
      _isloaging = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _commenttstream.cancel();

    commentcontoller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final postprovidr = Provider.of<PostProvider>(context);
    final auth = Provider.of<Authprovider>(context);
    return _isloaging
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          )
        : Container(
            height: media.height,
            width: double.infinity,
            color: Colors.grey[100],
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: _commentList.length,
                      itemBuilder: (ctx, ind) =>
                          CommentsWindow(comment: _commentList[ind])),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 168, 238, 98)))),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Consumer<Authprovider>(
                        builder: (ctx, value, ch) => CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage(value.getdattttta.imageURL)),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                          width: media.width * .55,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.length == 0) {
                                return 'pleas write some thing first ';
                              } else {
                                return null;
                              }
                            },
                            controller: commentcontoller,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'write a comment...'),
                          )),
                      TextButton(
                          onPressed: () async {
                            if (commentcontoller.text.length == 0 ||
                                commentcontoller.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text(' pleas enter acomment first')));
                            } else {
                              // setState(() {
                              //   _isloaging = true;
                              // });
                              final commentid = Uuid().v1();
                              await postprovidr.commentpost(
                                  Comment(
                                      likes: [],
                                      commentid: commentid,
                                      commentText: commentcontoller.text,
                                      timedate:
                                          Timestamp.fromDate(DateTime.now()),
                                      postid: widget.postid,
                                      useridd: auth.getdattttta.uid,
                                      commenterimage: auth.getdattttta.imageURL,
                                      commentername: auth.getdattttta.name),
                                  context);
                            }
                            // setState(() {
                            //   _isloaging = false;
                            // });
                          },
                          child:
                              // _isloaging? CircularProgressIndicator():
                              Text('Comment')),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
