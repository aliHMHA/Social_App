import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/widgets/text_input_field.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/providers/chatANDuploadController.dart';
import 'package:flutter_complete_guide/screens/chat_to_Afriend_screen.dart';
import 'package:flutter_complete_guide/screens/signup_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cofirm = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> loginuser() async {
    if (_emailController.text.isNotEmpty &
        _passwordController.text.isNotEmpty) {
      setState(() {
        _isloading = true;
      });

      await Provider.of<Authprovider>(context, listen: false)
          .signin(_emailController.text, _passwordController.text, context);

      setState(() {
        _isloading = false;
      });
    } else {
      ChatAndUploadController()
          .showsnackbarr(context, 'pleas compllet the field ');
    }
  }

  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;

    void changelog() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
    }

    return Scaffold(
        body: Container(
      height: _media.height,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(
        children: [
          Flexible(
            child: Container(),
            flex: 2,
          ),
          Text(
            'Social App',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 24),
          Textfieldinput(
              hinttext: 'Enter your email',
              textcontroller: _emailController,
              ispassword: false,
              texttype: TextInputType.emailAddress),
          const SizedBox(height: 24),
          Textfieldinput(
              hinttext: 'Enter your password',
              textcontroller: _passwordController,
              ispassword: true,
              texttype: TextInputType.emailAddress),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: loginuser,
            child: Container(
              // decoration: BoxDecoration(
              //     color: Colors.blue,
              //     borderRadius: const BorderRadius.all(Radius.circular(10))),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              width: double.infinity,
              child: _isloading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Log in',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
            ),
          ),
          Flexible(
            child: Container(),
            flex: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text('Dont have an account'),
              ),
              const SizedBox(width: 3),
              GestureDetector(
                onTap: changelog,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
