import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/widgets/text_input_field.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/providers/chatANDuploadController.dart';
import 'package:flutter_complete_guide/screens/login_creen.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _confirmpassController = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();

  bool _isloading = false;
  File? profileimage;
  File? coverimag;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _confirmpassController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    final auth = Provider.of<Authprovider>(context, listen: false);

    // Pick an image

    Future<void> adduser() async {
      if (_emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _bioController.text.isEmpty ||
          _usernameController.text.isEmpty ||
          _phonecontroller.text.isEmpty ||
          profileimage == null ||
          coverimag == null) {
        ChatAndUploadController()
            .showsnackbarr(context, 'pleas enter the fields and a pic');
      } else {
        setState(() {
          _isloading = true;
        });
        await auth.regester(
            bio: _bioController.text,
            email: _emailController.text,
            name: _usernameController.text,
            password: _passwordController.text,
            phone: _phonecontroller.text,
            coverimage: coverimag!,
            profilepic: profileimage!,
            context: context);

        setState(() {
          _isloading = false;
        });
      }
    }

    void changelod() {
      Navigator.of(context).pop();
    }

    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Social App',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: _media.height * .25,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: _media.height * .2,
                          child: coverimag == null
                              ? Image(
                                  image: AssetImage(
                                      'assets/images/placeHolder3.jpg'),
                                  fit: BoxFit.cover,
                                )
                              : Image(
                                  image: FileImage(coverimag!),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 65,
                            child: profileimage == null
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundImage: AssetImage(
                                        'assets/images/placeHolder1.jpg'))
                                : CircleAvatar(
                                    radius: 60,
                                    backgroundImage: FileImage(profileimage!)),
                          ),
                        ),
                        Positioned(
                            right: 7,
                            top: 7,
                            child: InkWell(
                              onTap: () async {
                                coverimag = await ChatAndUploadController()
                                    .showdialogforimagepick(
                                        context: context, media: _media);
                                setState(() {});
                              }, //coverimage
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: CircleAvatar(
                                  radius: 13,
                                  child: Icon(Icons.camera_alt),
                                ),
                              ),
                            )),
                        Positioned(
                            right: _media.width * .32,
                            bottom: 13,
                            child: InkWell(
                              onTap: () async {
                                profileimage = await ChatAndUploadController()
                                    .showdialogforimagepick(
                                        context: context, media: _media);
                                setState(() {});
                              }, //coverimage //profilepic
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: CircleAvatar(
                                  radius: 13,
                                  child: Icon(Icons.camera_alt),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: Textfieldinput(
                        hinttext: 'Enter your email',
                        textcontroller: _emailController,
                        ispassword: false,
                        texttype: TextInputType.emailAddress),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: Textfieldinput(
                        hinttext: 'Enter your username',
                        textcontroller: _usernameController,
                        ispassword: false,
                        texttype: TextInputType.text),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: Textfieldinput(
                        hinttext: 'Enter your password',
                        textcontroller: _passwordController,
                        ispassword: true,
                        texttype: TextInputType.emailAddress),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: Textfieldinput(
                        hinttext: 'Enter your bio',
                        textcontroller: _bioController,
                        ispassword: false,
                        texttype: TextInputType.text),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: Textfieldinput(
                        hinttext: 'Phone',
                        textcontroller: _phonecontroller,
                        ispassword: false,
                        texttype: TextInputType.text),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: adduser,
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
                        'Signup',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
              ),
            ),
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
                onTap: changelod,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    'Login',
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
