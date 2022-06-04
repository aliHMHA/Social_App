import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifactionScreen extends StatefulWidget {
  @override
  State<VerifactionScreen> createState() => _VerifactionScreenState();
}

class _VerifactionScreenState extends State<VerifactionScreen> {
  @override
  Widget build(BuildContext context) {
    bool _isloading = false;

    Future<void> emailverifecation() async {
      try {
        await FirebaseAuth.instance.currentUser!
            .sendEmailVerification()
            .then((value) {
          _isloading = false;
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('Its Done'),
                    content: Text('Check your email an email have been sent'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'ok',
                            style: TextStyle(fontSize: 25),
                          ))
                    ],
                  ));
        });
      } catch (error) {
        print(error.toString());
      }
    }

    return _isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('chate'),
            ),
            body: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .2,
                  ),
                  Icon(
                    Icons.email_outlined,
                    size: 100,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'pleas verify your email first.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isloading = true;
                        });

                        emailverifecation();
                      },
                      child: Text(
                        'Verify Now',
                        style: TextStyle(fontSize: 25),
                      )),
                  TextButton.icon(
                      onPressed: () {
                        // Navigator.pushReplacementNamed(
                        //     context, EmailVerifactionScreencheck.assasrout);
                      },
                      icon: Icon(Icons.refresh),
                      label: Text('refresh '))
                ],
              ),
            ),
          );
  }
}
