import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/mesage_model.dart';
import 'package:flutter_complete_guide/models/user_model.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/providers/chatANDuploadController.dart';
import 'package:flutter_complete_guide/screens/widgets/chat_bubble.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatToAFriendScreen extends StatefulWidget {
  final SocialUser currentChater;

  ChatToAFriendScreen(this.currentChater);
  static const chattofriendrout = 'Chatscreen./';

  @override
  State<ChatToAFriendScreen> createState() => _ChatToAFriendScreenState();
}

class _ChatToAFriendScreenState extends State<ChatToAFriendScreen> {
  @override
  void initState() {
    super.initState();
    chatStream();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    _chatstream.cancel();
  }

  File? _pickedimage;

  bool _isloaging = true;
  List<MessageModel> _chatlist = [];
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _chatstream;

  chatStream() {
    _chatlist.clear();
    _chatstream = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(widget.currentChater.uid)
        .collection('messages')
        .orderBy('timeDate')
        .snapshots()
        .listen((event) {
      _chatlist = [];
      for (var element in event.docs) {
        _chatlist.add(MessageModel.fromJeson(element.data()));
      }
      setState(() {});
    });
    setState(() {
      _isloaging = false;
    });
  }

  final _controller = TextEditingController();
  bool _issendingmessage = false;
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final authprov = Provider.of<Authprovider>(context).getdattttta;

    return _isloaging
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leadingWidth: 40,
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CircleAvatar(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: const AssetImage(
                                'assets/images/placeHolder1.jpg'),
                            image: NetworkImage(widget.currentChater.imageURL)),
                      ),
                      radius: 25,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    widget.currentChater.name,
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            body: // SingleChildScrollView(
                Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: Stack(
                      children: [
                        ListView.builder(
                            itemCount: _chatlist.length,
                            itemBuilder: (ctx, inde) {
                              if (_chatlist[inde].userid == authprov.uid) {
                                return ChatBubble(
                                  isyourmessage: true,
                                  message: _chatlist[inde],
                                );
                              } else {
                                return ChatBubble(
                                  isyourmessage: false,
                                  message: _chatlist[inde],
                                );
                              }
                            }),
                        if (_pickedimage != null)
                          Container(
                              padding: EdgeInsets.only(left: 5),
                              alignment: Alignment.bottomLeft,
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _pickedimage = null;
                                    });
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(fontSize: 20),
                                  ))),
                      ],
                    ),
                  ),
                ),
                if (_pickedimage != null)
                  Container(
                    alignment: Alignment.center,
                    color: Color.fromARGB(255, 205, 232, 179),
                    child: Image.file(
                      _pickedimage!,
                      fit: BoxFit.cover,
                      height: media.height * .45,
                      width: media.width,
                    ),
                    padding:
                        EdgeInsets.only(top: 7, left: 7, right: 7, bottom: 7),
                  ),
                Container(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(width: 1, color: Colors.grey.shade400)),
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        // width: media.width * .7,
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          controller: _controller,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              label: Text(
                                'Enter a message ...',
                                style: TextStyle(fontSize: 18),
                              )),
                        ),
                      ),
                      GestureDetector(
                          onTap: () async {
                            _pickedimage = await ChatAndUploadController()
                                .showdialogforimagepick(
                                    context: context, media: media);
                            if (_pickedimage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('No image was picked')));
                            }
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.attach_file_sharp,
                              size: 30,
                              color: Colors.blue,
                            ),
                          )),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            _issendingmessage = true;
                          });

                          String? imageurl;
                          if (_controller.text.isNotEmpty) {
                            if (_pickedimage != null) {
                              String imageuid = Uuid().v1();

                              imageurl = await ChatAndUploadController()
                                  .uploadMethod(
                                      uidsubfolder: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      firstfolder: 'messagesimages',
                                      file: _pickedimage!,
                                      ispost: false,
                                      postidOrimagname: imageuid);
                            }

                            ChatAndUploadController().sendamesageto(
                                MessageModel(
                                    imageurl: imageurl,
                                    userid: authprov.uid,
                                    reseverid: widget.currentChater.uid,
                                    messageText: _controller.text,
                                    timeDate: DateTime.now().toString()));
                            _controller.clear();
                          } else {
                            if (_pickedimage != null) {
                              String imageuid = Uuid().v1();

                              imageurl = await ChatAndUploadController()
                                  .uploadMethod(
                                      uidsubfolder: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      firstfolder: 'messagesimages',
                                      file: _pickedimage!,
                                      ispost: false,
                                      postidOrimagname: imageuid);

                              ChatAndUploadController().sendamesageto(
                                  MessageModel(
                                      imageurl: imageurl,
                                      userid: authprov.uid,
                                      reseverid: widget.currentChater.uid,
                                      messageText: _controller.text,
                                      timeDate: DateTime.now().toString()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'pleas enter a message or an image')));
                            }
                          }
                          setState(() {
                            _issendingmessage = false;
                            _pickedimage = null;
                          });
                        },
                        child: Container(
                          height: 60,
                          alignment: Alignment.center,
                          width: media.width * .15,
                          color: Colors.amber,
                          child: _issendingmessage
                              ? CircularProgressIndicator(
                                  color: Colors.black,
                                )
                              : Container(
                                  height: media.width * .16,
                                  child: Icon(Icons.send),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            // ),
          );
  }
}


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










  //  color:
  //                                           Color.fromARGB(255, 205, 232, 179),

  