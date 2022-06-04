import 'package:flutter/material.dart';

import '../../models/mesage_model.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {Key? key, required this.message, required this.isyourmessage})
      : super(key: key);

  final MessageModel message;
  final bool isyourmessage;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Align(
      alignment: isyourmessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
        decoration: isyourmessage
            ? BoxDecoration(
                color: Color.fromARGB(255, 205, 232, 179),
                borderRadius: BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(20),
                    topEnd: Radius.circular(20),
                    topStart: Radius.circular(20)),
              )
            : BoxDecoration(
                color: Color.fromARGB(255, 213, 215, 243),
                borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(20),
                    topEnd: Radius.circular(20),
                    topStart: Radius.circular(20))),
        child: Column(
          children: [
            if (message.imageurl != null)
              Container(
                  margin: EdgeInsets.only(top: 5),
                  height: media.height * .3,
                  width: media.width * .5,
                  child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder:
                          const AssetImage('assets/images/placeHolder2.jpg'),
                      image: NetworkImage(message.imageurl!))),
            Container(
              margin: message.imageurl != null
                  ? EdgeInsets.only(top: 5)
                  : EdgeInsets.only(top: 10),
              child: Text(
                message.messageText,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Color.fromARGB(255, 205, 232, 179)