import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/post_model.dart';
import 'package:flutter_complete_guide/screens/widgets/post_visual_model.dart';
import 'package:flutter_complete_guide/models/share_model.dart';
import 'package:intl/intl.dart';

class SharePreview extends StatefulWidget {
  const SharePreview({
    Key? key,
  }) : super(key: key);

  @override
  State<SharePreview> createState() => _SharePreviewState();
}

class _SharePreviewState extends State<SharePreview> {
  @override
  void initState() {
    super.initState();
    getshare();
  }

//get snap

  List<Sharemodel> sharelist = [];
  getshare() async {
    setState(() {
      _isloadinginit = true;
    });

    sharelist = [];
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('share')
        .get();

    for (var element in snap.docs) {
      sharelist.add(Sharemodel.fromsnap(element));
    }

    setState(() {
      _isloadinginit = false;
    });
  }

  bool _isloadinginit = false;

  @override
  Widget build(BuildContext context) {
    if (_isloadinginit == true) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ),
      );
    } else {
      List<String> postidlist = [];
      postidlist = [];

      for (var element in sharelist) {
        postidlist.add(element.postid);
      }

      return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
              if (snap.connectionState == ConnectionState.waiting ||
                  snap.connectionState == ConnectionState.none ||
                  snap.connectionState == ConnectionState.done) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ),
                );
              } else {
                List<Postinfo> postslist = [];

                for (var element in snap.data!.docs) {
                  if (postidlist.contains(Postinfo.fromsnap(element).postid)) {
                    postslist.add(Postinfo.fromsnap(element));
                  }
                }

                return postslist.isEmpty
                    ? Center(
                        child: Text(
                          'No notifications yet',
                          style: TextStyle(fontSize: 25),
                        ),
                      )
                    : ListView.builder(
                        itemCount: postslist.length,
                        itemBuilder: (ctx, ind) {
                          return Container(
                            child: Column(children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          child: CircleAvatar(
                                            child: SizedBox(
                                              width: 70,
                                              height: 70,
                                              child: FadeInImage(
                                                  fit: BoxFit.cover,
                                                  placeholder: const AssetImage(
                                                      'assets/images/placeHolder1.jpg'),
                                                  image: NetworkImage(
                                                      sharelist[ind]
                                                          .senderimageurl)),
                                            ),
                                            radius: 35,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 7.5),
                                                child: Text(
                                                  sharelist[ind].sendername,
                                                  style: TextStyle(
                                                      color: Colors.blue[400],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22),
                                                ),
                                              ),
                                              SizedBox(),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 7.5),
                                                child: Text(
                                                  'Shared this post with you',
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Text(
                                              DateFormat.yMMMMd().format(
                                                  sharelist[ind]
                                                      .timedate
                                                      .toDate()),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 22),
                                    child: Text(
                                      sharelist[ind].message,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                              Postvisualwidget(
                                sharebuttonOnOrOff: false,
                                post: postslist[ind],
                              )
                            ]),
                          );
                        });
              }
            }),
      );
    }
  }
}
