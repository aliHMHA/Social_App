import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/comment_model.dart';
import 'package:flutter_complete_guide/models/post_model.dart';
import 'package:flutter_complete_guide/models/user_model.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/providers/post_provider.dart';
import 'package:flutter_complete_guide/screens/comments_bottomSheet_screen.dart';
import 'package:flutter_complete_guide/screens/bottom_nav_screens.dart/profile_screen.dart';
import 'package:flutter_complete_guide/screens/image_preview_screen.dart';
import 'package:flutter_complete_guide/screens/searsh_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Postvisualwidget extends StatefulWidget {
  final Postinfo post;
  final bool sharebuttonOnOrOff;

  Postvisualwidget({required this.post, required this.sharebuttonOnOrOff});

  @override
  State<Postvisualwidget> createState() => _PostvisualwidgetState();
}

class _PostvisualwidgetState extends State<Postvisualwidget> {
  String userid = FirebaseAuth.instance.currentUser!.uid;

  void showcommentbottomsheet(BuildContext ctx, String postid) {
    showBottomSheet(
        context: ctx,
        builder: (_) {
          return CommentBottomSeetScreen(postid: postid);
        });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final auth = Provider.of<Authprovider>(context);
    final postprov = Provider.of<PostProvider>(context, listen: false);
    final commentcontoller = TextEditingController();

    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 3,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            children: [
              InkWell(
                  onTap: () async {
                    final snap = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.post.uid)
                        .get();

                    final SocialUser postowneruser =
                        SocialUser.fromJeson(snap.data()!);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => Profilescreen(
                                  ownerid: postowneruser.uid,
                                  isfromsearsh: true,
                                )));
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          border: BorderDirectional(
                              bottom: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 152, 155, 141)))),
                      padding: EdgeInsets.all(7),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CircleAvatar(
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: FadeInImage(
                                    fit: BoxFit.cover,
                                    placeholder: const AssetImage(
                                        'assets/images/placeHolder1.jpg'),
                                    image: NetworkImage(widget.post.imageURL)),
                              ),
                              radius: 30,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.post.name,
                                    style: TextStyle(fontSize: 19),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Icon(
                                    Icons.account_circle_rounded,
                                    color: Color.fromRGBO(127, 250, 65, 1),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                widget.post.timeDate,
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                          Spacer(),
                          if (widget.sharebuttonOnOrOff)
                            IconButton(
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => SearshScreen(
                                              shareORprofile: true,
                                              postid: widget.post.postid,
                                            ))));
                              },
                              icon: Icon(
                                Icons.reply,
                                color: Color.fromARGB(221, 158, 128, 234),
                              ),
                              iconSize: 35,
                            )
                        ],
                      ))),
              SizedBox(height: 7),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(
                  widget.post.postText,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        '# flutter',
                        style: TextStyle(fontSize: 20),
                      )),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        '# Development',
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ),
              if (widget.post.postImage != null)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => ImagePreviewScreen(
                            imageurl: widget.post.postImage!)));
                  },
                  child: Container(
                    height: media.height * .4,
                    width: double.infinity,
                    child: FadeInImage(
                      placeholder:
                          const AssetImage('assets/images/placeHolder2.jpg'),
                      image: NetworkImage(widget.post.postImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                height: media.height * .06,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(alignment: Alignment.center),
                      onPressed: () async {
                        await postprov.likepost(
                            postid: widget.post.postid,
                            context: context,
                            likes: widget.post.likes,
                            postownerid: widget.post.uid,
                            userid: userid);
                        print(userid);
                      },
                      icon: widget.post.likes.contains(userid)
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 25,
                            )
                          : Icon(
                              Icons.favorite_outline,
                              color: Colors.red,
                              size: 25,
                            ),
                      label: Text(
                        '${widget.post.likes.length.toString()} Likes',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showcommentbottomsheet(context, widget.post.postid);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            SizedBox(),
                            Text(
                                'view ${widget.post.commentsnum.length} Comments',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12)),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.comment,
                              color: Colors.purple,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(' pleas enter acomment first')));
                          } else {
                            final commentid = Uuid().v1();
                            await postprov.commentpost(
                                Comment(
                                    likes: [],
                                    commentid: commentid,
                                    commentText: commentcontoller.text,
                                    timedate:
                                        Timestamp.fromDate(DateTime.now()),
                                    postid: widget.post.postid,
                                    useridd: auth.getdattttta.uid,
                                    commenterimage: auth.getdattttta.imageURL,
                                    commentername: auth.getdattttta.name),
                                context);
                          }
                        },
                        child: Text('Comment')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}



// Future<void> getlikesandcomments() async {
  //   await FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(postid)
  //       .collection('likes')
  //       .get()
  //       .then((value) async {
  //     _likesnumber = value.docs.length;
  //     await FirebaseFirestore.instance
  //         .collection('posts')
  //         .doc(postid)
  //         .collection('comments')
  //         .get()
  //         .then((value) {
  //       _commentumber = value.docs.length;
  //     }).catchError((error) {});
  //   }).catchError((error) {});
  // }




  // ClipRRect(
  //                       borderRadius: BorderRadius.circular(40),
  //                       child: CircleAvatar(
  //                         child: SizedBox(
  //                           width: 80,
  //                           height:  80,
  //                           child: FadeInImage(
  //                               fit: BoxFit.cover,
  //                               placeholder: const AssetImage(
  //                                   'assets/images/placeHolder1.jpg'),
  //                               image: NetworkImage(_profilowner.photo)),
  //                         ),
  //                         radius: 40,
  //                       ),
  //                     ),