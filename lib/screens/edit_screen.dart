import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/user_model.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/providers/chatANDuploadController.dart';
import 'package:flutter_complete_guide/providers/edit_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditeScreen extends StatefulWidget {
  static const editScreen = '/ edietscreen ';

  @override
  State<EditeScreen> createState() => _EditeScreenState();
}

class _EditeScreenState extends State<EditeScreen> {
  final _llllll = GlobalKey<FormState>();

  String? _Phone;

  String? _name;

  // String? _image;
  String? _boi;

  // String? _Cover;
  bool profilupdateload = false;
  bool coverupdateload = false;
  bool totalsave = false;

  File? _selectedprofileImage;
  File? _selectedCoverImage;

  @override
  Widget build(BuildContext context) {
    final authprov = Provider.of<Authprovider>(context, listen: false);
    final editeprov = Provider.of<EditProvider>(context);

    final media = MediaQuery.of(context).size;
    SocialUser datta = authprov.getdattttta;

    Future<void> saveEdiet() async {
      final isValidate = _llllll.currentState!.validate();
      if (!isValidate) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(' pleas complete ur fields')));
      } else {
        try {
          _llllll.currentState!.save();
          await editeprov.edite(
              user: datta, bio: _boi, name: _name, context: context);
        } catch (error) {}
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edite screen '),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: media.height * .3,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: media.height * .22,
                      child: _selectedCoverImage == null
                          ? FadeInImage(
                              placeholder: const AssetImage(
                                  'assets/images/placeHolder2.jpg'),
                              image: NetworkImage(datta.coverURL),
                              fit: BoxFit.cover,
                            )
                          : Image(
                              image: FileImage(_selectedCoverImage!),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 65,
                        child: _selectedprofileImage == null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: CircleAvatar(
                                  child: SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: FadeInImage(
                                        fit: BoxFit.cover,
                                        placeholder: const AssetImage(
                                            'assets/images/placeHolder1.jpg'),
                                        image: NetworkImage(datta.imageURL)),
                                  ),
                                  radius: 60,
                                ),
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    FileImage(_selectedprofileImage!)),
                      ),
                    ),
                    Positioned(
                        right: 7,
                        top: 7,
                        child: InkWell(
                          onTap: () async {
                            _selectedCoverImage =
                                await ChatAndUploadController()
                                    .showdialogforimagepick(
                                        context: context, media: media);
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
                        right: media.width * .32,
                        bottom: 13,
                        child: InkWell(
                          onTap: () async {
                            _selectedprofileImage =
                                await ChatAndUploadController()
                                    .showdialogforimagepick(
                                        context: context, media: media);
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
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue[400]),
                          onPressed: () {
                            if (_selectedprofileImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'pleas sellect an image first')));
                            } else {
                              setState(() {
                                profilupdateload = true;
                              });
                              editeprov
                                  .uploadProfilImage(
                                      _selectedprofileImage!, context)
                                  .then((value) {
                                editeprov
                                    .edite(
                                        user: datta,
                                        bio: _boi,
                                        name: _name,
                                        context: context)
                                    .then((value) {
                                  setState(() {
                                    profilupdateload = false;
                                  });
                                });
                              });
                            }
                          },
                          child: Text(
                            'update profle pic',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        if (profilupdateload) LinearProgressIndicator()
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue[400]),
                          onPressed: () {
                            if (_selectedCoverImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'pleas sellect an image first')));
                            } else {
                              setState(() {
                                coverupdateload = true;
                              });
                              editeprov
                                  .uploadCoverImage(
                                      _selectedCoverImage!, context)
                                  .then((value) {
                                editeprov
                                    .edite(
                                        user: datta,
                                        bio: _boi,
                                        name: _name,
                                        context: context)
                                    .then((value) {
                                  setState(() {
                                    coverupdateload = false;
                                  });
                                });
                              });
                            }
                          },
                          child: Text(
                            'update cover',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        if (coverupdateload) LinearProgressIndicator()
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 3,
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                  key: _llllll,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.length <= 3) {
                              return 'please enter a name consists of 3 charechters at least';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _name = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            labelText: 'phone',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (!value!.startsWith('0')) {
                              return 'please enter avalid number';
                            }
                            if (value.length != 11) {
                              return 'please enter anumber consists of 11 numbers';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _Phone = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'bio...',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter a bio';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _boi = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextButton.icon(
                            onPressed: () {
                              setState(() {
                                totalsave = true;
                              });
                              saveEdiet().then((value) {
                                setState(() {
                                  totalsave = false;
                                });
                              });
                            },
                            icon: Icon(Icons.save),
                            label: totalsave
                                ? CircularProgressIndicator()
                                : Text('save changes'))
                      ])),
            ],
          ),
        ),
      ),
    );
  }
}






// TextFormField(
                        //   decoration: InputDecoration(
                        //       prefixIcon: Icon(Icons.image),
                        //       labelText: 'Personal Image',
                        //       border: OutlineInputBorder()),
                        //   validator: (value) {
                        //     if (value.isEmpty) {
                        //       return 'please enter image url';
                        //     }
                        //     return null;
                        //   },
                        //   onSaved: (value) {
                        //     _image = value;
                        //   },
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // TextFormField(
                        //   decoration: InputDecoration(
                        //       prefixIcon: Icon(Icons.image_search),
                        //       labelText: 'cover Image',
                        //       border: OutlineInputBorder()),
                        //   validator: (value) {
                        //     if (value.isEmpty) {
                        //       return 'please enter image url';
                        //     }
                        //     return null;
                        //   },
                        //   onSaved: (value) {
                        //     _Cover = value;
                        //   },
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),

                        // TextFormField(
                        //   decoration: InputDecoration(
                        //       prefixIcon: Icon(Icons.mail),
                        //       labelText: 'email',
                        //       border: OutlineInputBorder()),
                        //   textInputAction: TextInputAction.next,
                        //   validator: (value) {
                        //     if (!value.endsWith('.com')) {
                        //       return 'please enter a valide email';
                        //     }
                        //     return null;
                        //   },
                        //   onSaved: (newValue) {
                        //     _Emal = newValue;
                        //   },
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // TextFormField(
                        //   obscureText: true,
                        //   decoration: InputDecoration(
                        //     prefixIcon: Icon(Icons.lock),
                        //     labelText: 'password',
                        //     border: OutlineInputBorder(),
                        //   ),
                        //   focusNode: passwordfocuss,
                        //   onEditingComplete: () {
                        //     FocusScope.of(context).requestFocus(confirmfocus);
                        //   },
                        //   controller: passwordcontroller,
                        //   validator: (value) {
                        //     if (value.length <= 7) {
                        //       return 'password must have 8 or more';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // TextFormField(
                        //   obscureText: true,
                        //   decoration: InputDecoration(
                        //     prefixIcon: Icon(Icons.arrow_right),
                        //     labelText: 'confirm password',
                        //     border: OutlineInputBorder(),
                        //   ),
                        //   onEditingComplete: () {
                        //     FocusScope.of(context).requestFocus(phonefocuse);
                        //   },
                        //   focusNode: confirmfocus,
                        //   validator: (value) {
                        //     if (value != passwordcontroller.text) {
                        //       return 'password not similar';
                        //     }
                        //     return null;
                        //   },
                        //   onSaved: (value) {
                        //     _confirmpass = value;
                        //   },
                        // ),