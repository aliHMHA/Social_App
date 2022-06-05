import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/post_model.dart';
import 'package:flutter_complete_guide/screens/widgets/post_visual_model.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/screens/searsh_screen.dart';
import 'package:flutter_complete_guide/screens/share_preview.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

//wellcom
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final autprov = Provider.of<Authprovider>(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        leading: SizedBox(),
        title: Text(
          'Home',
          style: TextStyle(
              fontSize: 25, fontFamily: 'Raleway', color: Colors.black),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => SharePreview()));
                  },
                  iconSize: 30),
              Positioned(
                left: 5,
                top: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 8,
                  child: Text(
                    autprov.getdattttta.sharesrecived!.length.toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              )
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return SearshScreen(
                  shareORprofile: false,
                );
              }));
            },
            icon: Icon(Icons.search_sharp, color: Colors.black54),
            iconSize: 30,
          )
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('timeDate', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snaps) {
            if (snaps.connectionState == ConnectionState.active) {
              return ListView.builder(
                itemCount: snaps.data!.docs.length,
                itemBuilder: (ctx, indd) => Postvisualwidget(
                  sharebuttonOnOrOff: true,
                  post: Postinfo.fromsnap(snaps.data!.docs[indd]),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 2, 248, 10)),
              );
            }
          }),
    );
  }
}
