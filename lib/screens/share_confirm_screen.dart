import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/widgets/post_visual_model.dart';
import 'package:flutter_complete_guide/models/user_model.dart';
import 'package:flutter_complete_guide/providers/post_provider.dart';
import 'package:provider/provider.dart';

import '../models/post_model.dart';

class ShareConfirmScreen extends StatefulWidget {
  final String postid;
  final SocialUser tosendTo;

  const ShareConfirmScreen(
      {Key? key, required this.postid, required this.tosendTo})
      : super(key: key);

  @override
  State<ShareConfirmScreen> createState() => ShareConfirmScreenState();
}

class ShareConfirmScreenState extends State<ShareConfirmScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    _poststream.cancel();
  }

  @override
  void initState() {
    super.initState();
    stream();
    getuser();
  }

  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _poststream;
  late Postinfo post;
  late SocialUser _currentusermodel;

  stream() async {
    _poststream = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postid)
        .snapshots()
        .listen((event) {
      post = Postinfo.fromsnap(event);
      setState(() {});
    });
  }

  getuser() async {
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    _currentusermodel = SocialUser.fromsnap(snap);

    setState(() {
      _isinitialLoading = false;
    });
  }

  bool _isinitialLoading = true;

  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    final postprov = Provider.of<PostProvider>(context, listen: false);
    final _media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: _isinitialLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child: TextField(
                    style: TextStyle(fontSize: 22),
                    controller: _controller,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(fontSize: 22, color: Colors.blue),
                        hintText: 'say some thing',
                        border: InputBorder.none),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Center(
                          child: Postvisualwidget(
                        post: post,
                        sharebuttonOnOrOff: false,
                      )),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(_media.width * .4, 45),
                        primary: Colors.amber,
                      ),
                      onPressed: () async {
                        setState(() {
                          _isloading = true;
                        });
                        await postprov.share(
                            reciverid: widget.tosendTo.uid,
                            postid: widget.postid,
                            message: _controller.text,
                            sendername: _currentusermodel.name,
                            senderimageurl: _currentusermodel.imageURL,
                            context: context);
                        setState(() {
                          _isloading = false;
                        });
                        Navigator.pop(context);
                      },
                      child: _isloading
                          ? CircularProgressIndicator(
                              color: Colors.black,
                            )
                          : Text(
                              'Share',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )),
                )
              ],
            ),
    );
  }
}
//  ClipRRect(
//                               borderRadius: BorderRadius.circular(30),
//                               child: CircleAvatar(
//                                 child: SizedBox(
//                                   width: 60,
//                                   height: 60,
//                                   child: FadeInImage(
//                                       fit: BoxFit.cover,
//                                       placeholder: const AssetImage(
//                                           'assets/images/placeHolder1.jpg'),
//                                       image: NetworkImage(
//                                           widget.post.profileimageurl)),
//                                 ),
//                                 radius: 30,
//                               ),
//                             ),
