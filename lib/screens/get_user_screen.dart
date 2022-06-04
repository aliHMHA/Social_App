import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/screens/bottom_nav_screens.dart/bottom_navigation_screen.dart';
import 'package:provider/provider.dart';

class Getuserscreen extends StatelessWidget {
  const Getuserscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authprovider>(context, listen: false);

    return FutureBuilder(
        future: auth.getdata(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            );
          } else {
            return BottomnNavigationScreen();
          }
        });
  }
}
