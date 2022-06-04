import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageurl;
  const ImagePreviewScreen({Key? key, required this.imageurl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FadeInImage(
          image: NetworkImage(imageurl),
          fit: BoxFit.cover,
          placeholder: const AssetImage('assets/images/placeHolder2.jpg'),
        ));
  }
}
