import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/providers/edit_provider.dart';
import 'package:flutter_complete_guide/providers/post_provider.dart';
import 'package:flutter_complete_guide/screens/edit_screen.dart';
import 'package:flutter_complete_guide/screens/bottom_nav_screens.dart/bottom_navigation_screen.dart';
import 'package:flutter_complete_guide/screens/get_user_screen.dart';
import 'package:flutter_complete_guide/screens/login_creen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MyApp());
}

@override
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    internitconiction();
  }

  late StreamSubscription<ConnectivityResult> subscription;
  internitconiction() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          _isconnected = false;
        });
      } else {
        setState(() {
          _isconnected = true;
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  bool _isconnected = true;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Authprovider()),
          ChangeNotifierProvider(create: (ctx) => EditProvider()),
          ChangeNotifierProvider(create: (ctx) => PostProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Social App',

          // themeMode: ThemeMode.dark,
          theme: ThemeData.light().copyWith(
              snackBarTheme:
                  SnackBarThemeData(contentTextStyle: TextStyle(fontSize: 15)),
              backgroundColor: Colors.grey[50],
              appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(color: Colors.black),
                elevation: 0,
                backgroundColor: Colors.grey[100],
              ),
              scaffoldBackgroundColor: Colors.grey[50]),

          home: !_isconnected
              ? Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.error_outline_sharp,
                          size: 100,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'No internet connection',
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          'please check it.',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                )
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshote) {
                    if (snapshote.connectionState == ConnectionState.active) {
                      if (snapshote.hasData) {
                        return const Getuserscreen();
                      } else if (snapshote.hasError) {
                        return Scaffold(
                          body: const Center(
                            child: Text('some error happend'),
                          ),
                        );
                      }
                    }
                    if (snapshote.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                        body: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        ),
                      );
                    }
                    return const LoginScreen();
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
