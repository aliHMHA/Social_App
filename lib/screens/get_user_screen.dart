import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/user_model.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/screens/bottom_nav_screens.dart/bottom_navigation_screen.dart';
import 'package:flutter_complete_guide/screens/login_creen.dart';
import 'package:provider/provider.dart';

class Getuserscreen extends StatelessWidget {
  const Getuserscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authprovider>(context, listen: false);

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snap) {
          if (snap.connectionState == ConnectionState.done) {
            if (snap.hasData) {
              auth.socialuserset = SocialUser.fromsnap(snap.data!);

              return BottomnNavigationScreen();
            } else if (snap.hasError) {
              return Scaffold(
                  body: Center(
                child: Text(
                  'An error occuerd',
                  style: TextStyle(fontSize: 40),
                ),
              ));
            }
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          }
          return LoginScreen();
        });
  }
}
