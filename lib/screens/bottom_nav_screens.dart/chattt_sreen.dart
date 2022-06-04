import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/chatANDuploadController.dart';
import 'package:flutter_complete_guide/screens/chat_to_Afriend_screen.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';

class Chatscreen extends StatefulWidget {
  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
              fillColor: Colors.white,
              hintStyle: TextStyle(
                color: Colors.blue,
                fontSize: 18,
              ),
              hintText: 'Searsh by name here.',
              border: InputBorder.none),
          onChanged: (ff) {
            setState(() {});
          },
        )),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('name', isGreaterThanOrEqualTo: _controller.text)
              .get(),
          builder:
              (ctx, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Container();
            } else {
              List usereswithoutyousnaplist = snap.data!.docs
                  .where((element) =>
                      SocialUser.fromsnap(element).uid !=
                      FirebaseAuth.instance.currentUser!.uid)
                  .toList();

              return ListView.builder(
                  itemCount: usereswithoutyousnaplist.length,
                  itemBuilder: ((context, index) {
                    SocialUser _socialuser =
                        SocialUser.fromsnap(usereswithoutyousnaplist[index]);
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (ctx) =>
                                  ChatToAFriendScreen(_socialuser)),
                        );
                      },
                      child: Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 10, top: 10, bottom: 10),
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
                                        image:
                                            NetworkImage(_socialuser.imageURL)),
                                  ),
                                  radius: 30,
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _socialuser.name,
                                  style: const TextStyle(fontSize: 25),
                                ),
                              ))
                            ],
                          )),
                    );
                  }));
            }
          },
        ));
  }
}
