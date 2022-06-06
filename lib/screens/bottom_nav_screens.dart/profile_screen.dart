import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/post_model.dart';
import 'package:flutter_complete_guide/screens/widgets/post_visual_model.dart';
import 'package:flutter_complete_guide/models/user_model.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/screens/chat_to_Afriend_screen.dart';
import 'package:flutter_complete_guide/screens/edit_screen.dart';
import 'package:flutter_complete_guide/screens/image_preview_screen.dart';
import 'package:provider/provider.dart';

class Profilescreen extends StatefulWidget {
  final String ownerid;
  final bool isfromsearsh;
  Profilescreen({required this.ownerid, required this.isfromsearsh});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  @override
  void initState() {
    super.initState();
    postStream();
    getusetr();
  }

  late SocialUser profileowner;
  bool _isloadinguser = true;
  late bool _isCurrentAfowllower;
  late int _followers;
  late int _following;
  getusetr() async {
    _isloadinguser = true;
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.ownerid)
          .get();

      profileowner = SocialUser.fromsnap(snap);

      _isCurrentAfowllower = profileowner.followers!
          .contains(FirebaseAuth.instance.currentUser!.uid);
      _followers = profileowner.followers!.length;
      _following = profileowner.following!.length;

      setState(() {
        _isloadinguser = false;
      });
    } catch (error) {
      throw error;
    }
  }

  List<Postinfo> _postslist = [];
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _postsstream;
  postStream() async {
    try {
      _postslist.clear();
      _postsstream = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.ownerid)
          .snapshots()
          .listen((event) {
        _postslist = [];
        for (var element in event.docs) {
          _postslist.add(Postinfo.fromsnap(element));
        }
        setState(() {});
      });
    } catch (err) {
      throw (err);
    }
  }

  followOrUnfolow(String yourUserid, String theOnetofollowid) async {
    try {
      final _firestore = FirebaseFirestore.instance;
      final snap =
          await _firestore.collection('users').doc(theOnetofollowid).get();
      SocialUser theOnetofollow = SocialUser.fromsnap(snap);
      if (theOnetofollow.followers!.contains(yourUserid)) {
        _firestore.collection('users').doc(theOnetofollow.uid).update({
          'followers': FieldValue.arrayRemove([yourUserid])
        });
        _firestore.collection('users').doc(yourUserid).update({
          'following': FieldValue.arrayRemove([theOnetofollow.uid])
        });
      } else {
        _firestore.collection('users').doc(theOnetofollow.uid).update({
          'followers': FieldValue.arrayUnion([yourUserid])
        });
        _firestore.collection('users').doc(yourUserid).update({
          'following': FieldValue.arrayUnion([theOnetofollow.uid])
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _postsstream.cancel();
  }

  late bool ownerIScurrentuser;

  @override
  Widget build(BuildContext context) {
    ownerIScurrentuser =
        FirebaseAuth.instance.currentUser!.uid == widget.ownerid;
    final authprov = Provider.of<Authprovider>(context);

    final media = MediaQuery.of(context).size;
    String currentuserid = authprov.getdattttta.uid;
    return _isloadinguser
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          )
        : Scaffold(
            appBar: widget.isfromsearsh ? AppBar() : null,
            floatingActionButton: widget.isfromsearsh
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, EditeScreen.editScreen);
                    },
                    child: Icon(
                      Icons.edit,
                      size: 35,
                    ),
                    backgroundColor: Colors.blue[400],
                  ),
            body: Container(
              height: media.height,
              margin: widget.isfromsearsh
                  ? EdgeInsets.only(bottom: 5, top: 5)
                  : EdgeInsets.only(
                      bottom: 5,
                      top: MediaQuery.of(context).viewPadding.top + 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: media.height * .30,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => ImagePreviewScreen(
                                    imageurl: profileowner.coverURL)));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: media.height * .22,
                            child: FadeInImage(
                              placeholder: const AssetImage(
                                  'assets/images/placeHolder2.jpg'),
                              image: NetworkImage(profileowner.coverURL),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 65,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => ImagePreviewScreen(
                                        imageurl: profileowner.imageURL)));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: CircleAvatar(
                                  child: SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: FadeInImage(
                                        fit: BoxFit.cover,
                                        placeholder: const AssetImage(
                                            'assets/images/placeHolder1.jpg'),
                                        image: NetworkImage(
                                            profileowner.imageURL)),
                                  ),
                                  radius: 60,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    profileowner.name,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    profileowner.bio,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      clooomn(profileowner.posts!.length.toString(), 'Posts'),
                      clooomn(_followers.toString(), 'followers'),
                      clooomn(profileowner.likes!.length.toString(), 'Likes'),
                      clooomn(
                          profileowner.comments!.length.toString(), 'Comments'),
                    ],
                  ),
                  if (ownerIScurrentuser)
                    TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        child: Text(
                          'Log out',
                          style: TextStyle(fontSize: 18),
                        )),
                  SizedBox(
                    height: 5,
                  ),
                  if (profileowner.uid != currentuserid)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isCurrentAfowllower
                                  ? () {
                                      followOrUnfolow(
                                          profileowner.uid, widget.ownerid);
                                      setState(() {
                                        _followers--;
                                        _isCurrentAfowllower = false;
                                      });
                                    }
                                  : () {
                                      followOrUnfolow(
                                          profileowner.uid, widget.ownerid);
                                      setState(() {
                                        _followers++;
                                        _isCurrentAfowllower = true;
                                      });
                                    },
                              child: _isCurrentAfowllower
                                  ? Text(
                                      'Unfollow',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    )
                                  : Text(
                                      'Follow',
                                      style: TextStyle(fontSize: 18),
                                    ),
                              style: _isCurrentAfowllower
                                  ? ElevatedButton.styleFrom(
                                      primary: Colors.white)
                                  : ElevatedButton.styleFrom(
                                      primary: Colors.blue),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ChatToAFriendScreen(profileowner)));
                            },
                            child: Text(
                              'Start a chat',
                              style: TextStyle(fontSize: 18),
                            ),
                            style: TextButton.styleFrom(),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Postvisualwidget(
                            post: _postslist[index],
                            sharebuttonOnOrOff: ownerIScurrentuser);
                      },
                      itemCount: _postslist.length,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

class clooomn extends StatelessWidget {
  final String numerd;
  final String word;
  clooomn(this.numerd, this.word);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          numerd,
          style: TextStyle(
              fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 17),
        ),
        FittedBox(child: Text(word, style: TextStyle(fontSize: 15)))
      ],
    );
  }
}

// https://img.freepik.com/free-photo/cup-coffee-coffee-beans_164008-356.jpg?w=740


                          // https://img.freepik.com/free-photo/beautiful-female-with-blonde-long-hair-has-confident-expression-wears-casual-sweater-isolated-pink-wall-adorable-young-woman-has-attractive-look-poses-waist-up-shot_273609-2438.jpg?w=740
