import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/providers/edit_provider.dart';
import 'package:flutter_complete_guide/providers/post_provider.dart';
import 'package:flutter_complete_guide/screens/edit_screen.dart';
import 'package:flutter_complete_guide/screens/bottom_nav_screens.dart/bottom_navigation_screen.dart';
import 'package:flutter_complete_guide/screens/get_user_screen.dart';
import 'package:flutter_complete_guide/screens/login_creen.dart';
import 'package:flutter_complete_guide/screens/verifiction%20_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('on background');

  print(message.data.toString());

  Fluttertoast.showToast(
      msg: 'on backgrouned message',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MyApp());
}

@override
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance
        .getToken()
        .then((value) => print(' hassanmmm  $value'));

    FirebaseMessaging.onMessage.listen((event) {
      print(event.data.toString());

      Fluttertoast.showToast(
          msg: "On messages",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event.data.toString());
      Fluttertoast.showToast(
          msg: " On Message openedapp",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Authprovider()),
          ChangeNotifierProxyProvider<Authprovider, EditProvider>(
              create: (ctx) => EditProvider(),
              update: (ctx, auth, priviosedite) {
                return priviosedite!..tttrrrrr = auth.getdattttta;
              }),
          ChangeNotifierProxyProvider<Authprovider, PostProvider>(
            create: (ctx) => PostProvider(),
            update: (ctx, auth, postprv) {
              return postprv!..userinfo = auth.getdattttta;
            },
          ),
          // ChangeNotifierProxyProvider<Authprovider, ChatProvider>(
          //   create: (ctx) => ChatProvider(),
          //   update: (ctx, auth, privioschat) {
          //     return privioschat!..currentuser = auth.getdattttta;
          //   },
          // ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Social App',

          // themeMode: ThemeMode.dark,
          theme: ThemeData.light().copyWith(
              appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.grey[100],
          )),

          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.active) {
                if (snap.hasData) {
                  bool _isverified =
                      FirebaseAuth.instance.currentUser!.emailVerified;

                  return _isverified ? Getuserscreen() : VerifactionScreen();
                } else {
                  return LoginScreen();
                }
              } else if (snap.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                      child: CircularProgressIndicator(
                    color: Colors.green,
                  )),
                );
              } else
                return LoginScreen();
            },
          ),

          routes: {
            BottomnNavigationScreen.maiiiwroute: (ctx) =>
                BottomnNavigationScreen(),
            EditeScreen.editScreen: (ctx) => EditeScreen(),
          },
        ));
  }
}
