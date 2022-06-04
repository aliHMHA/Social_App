import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/user_model.dart';
import 'package:flutter_complete_guide/screens/bottom_nav_screens.dart/profile_screen.dart';
import 'package:flutter_complete_guide/screens/share_confirm_screen.dart';

class SearshScreen extends StatefulWidget {
  final bool shareORprofile;
  final String? postid;
  const SearshScreen({Key? key, required this.shareORprofile, this.postid})
      : super(key: key);

  @override
  State<SearshScreen> createState() => _SearshScreenState();
}

class _SearshScreenState extends State<SearshScreen> {
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
          style: TextStyle(fontSize: 22),
          controller: _controller,
          decoration: widget.shareORprofile
              ? InputDecoration(
                  hintStyle: TextStyle(fontSize: 22, color: Colors.blue),
                  hintText: 'Send To...',
                  border: InputBorder.none)
              : InputDecoration(
                  hintStyle: TextStyle(fontSize: 22, color: Colors.blue),
                  hintText: 'Searsh for users here.',
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
              List<SocialUser> userslistwithoutyou = [];
              final newsnap = snap.data!.docs.where((element) =>
                  SocialUser.fromsnap(element).uid !=
                  FirebaseAuth.instance.currentUser!.uid);

              newsnap.forEach((element) {
                userslistwithoutyou.add(SocialUser.fromsnap(element));
              });

              return ListView.builder(
                  itemCount: userslistwithoutyou.length,
                  itemBuilder: ((context, index) {
                    SocialUser _socialuser = userslistwithoutyou[index];
                    return InkWell(
                      onTap: () {
                        if (widget.shareORprofile) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => ShareConfirmScreen(
                                    postid: widget.postid!,
                                    tosendTo: _socialuser)),
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => Profilescreen(
                                      ownerid: _socialuser.uid,
                                      isfromsearsh: true,
                                    )),
                          );
                        }
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
