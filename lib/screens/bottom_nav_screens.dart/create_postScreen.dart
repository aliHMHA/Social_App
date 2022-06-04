import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/providers/chatANDuploadController.dart';
import 'package:flutter_complete_guide/providers/post_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  State<CreatePostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<CreatePostScreen> {
  File? _imagetoupload;

  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    final authprov = Provider.of<Authprovider>(context, listen: false);
    final data = authprov.getdattttta;
    final postprov = Provider.of<PostProvider>(context);
    final media = MediaQuery.of(context).size;

    var postcontroller = TextEditingController();

    return Scaffold(
      body: Container(
        height: media.height,
        margin: EdgeInsets.only(
            left: 5,
            right: 5,
            bottom: 5,
            top: MediaQuery.of(context).viewPadding.top),
        width: media.width,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.grey)),
                            color: Color.fromARGB(234, 227, 239, 234)),
                        padding: EdgeInsets.all(7),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(data.imageURL),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      data.name,
                                      style: TextStyle(fontSize: 19),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Icon(
                                      Icons.account_circle_rounded,
                                      color: Color.fromRGBO(127, 250, 65, 1),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  data.bio,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                            Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.amber),
                              child: _isloading
                                  ? CircularProgressIndicator(
                                      color: Colors.black,
                                    )
                                  : Text(
                                      'POST',
                                      style: TextStyle(fontSize: 15),
                                    ),
                              onPressed: () async {
                                setState(() {
                                  _isloading = true;
                                });
                                if (postcontroller.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: 'pleas enter some thing',
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.black);
                                } else if (_imagetoupload == null) {
                                  await postprov.createpost(
                                      postcontroller.text, null);
                                } else {
                                  await postprov.creatpostwithimage(
                                      postcontroller.text,
                                      _imagetoupload!,
                                      authprov.getdattttta.uid);
                                }
                                setState(() {
                                  _isloading = false;
                                });
                              },
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 7),
                      child: TextFormField(
                        style: TextStyle(fontSize: 22),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'say some thing',
                            hintStyle:
                                TextStyle(fontSize: 20, color: Colors.blue)),
                        maxLines: 3,
                        controller: postcontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleas enter some ting';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_imagetoupload != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Image.file(
                          _imagetoupload!,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.all(5),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      // side: BorderSide(width: 1, color: Colors.green),
                      primary: Colors.blue,
                      fixedSize: Size(media.width - 20, 50)),
                  onPressed: () async {
                    _imagetoupload = await ChatAndUploadController()
                        .showdialogforimagepick(context: context, media: media);
                    setState(() {});
                  },
                  label: Text(
                    'Add a pic',
                    style: TextStyle(fontSize: 20),
                  ),
                  icon: Icon(Icons.photo),
                ))
          ],
        ),
      ),
    );
  }
}
