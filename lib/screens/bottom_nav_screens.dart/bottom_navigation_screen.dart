import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/bottom_nav_screens.dart/Home_creen.dart';
import 'package:flutter_complete_guide/screens/bottom_nav_screens.dart/profile_screen.dart';
import 'package:flutter_complete_guide/screens/bottom_nav_screens.dart/chattt_sreen.dart';
import 'package:flutter_complete_guide/screens/bottom_nav_screens.dart/create_postScreen.dart';

class BottomnNavigationScreen extends StatefulWidget {
  static const maiiiwroute = './maiiiiiiiwwwwwnRout';
  @override
  _BottomNavigationScreenstat createState() => _BottomNavigationScreenstat();
}

class _BottomNavigationScreenstat extends State<BottomnNavigationScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    List<Map<String, Object>> _pages = [
      {'page': Home(), 'title': 'Home'},
      {'page': Chatscreen(), 'title': 'Chat'},
      {'page': CreatePostScreen(), 'title': 'New post'},
      {
        'page': Profilescreen(
          ownerid: FirebaseAuth.instance.currentUser!.uid,
          isfromsearsh: false,
        ),
        'title': 'Settings'
      }
    ];
    void _selectpage(int ind) {
      setState(() {
        _index = ind;
      });
    }

    return Scaffold(
      body: _pages[_index]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lime,
        backgroundColor: Colors.blue[400],
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: _selectpage,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded),
              label: 'Chat',
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: 'Post ',
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Theme.of(context).primaryColor)
        ],
      ),
    );
  }
}
