import 'package:flutter/material.dart';
import '../../component/Circle_Icon.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'dart:typed_data';

class ChatPage extends StatefulWidget {
  String uid;

  ChatPage({Key key, @required this.uid}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<int> test = [1, 1, 1, 1, 1, 1, 11, 1, 1, 1, 1, 11, 1, 1, 1, 1, 1];
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storageInstance =
      firebase_storage.FirebaseStorage.instance;

  QueryDocumentSnapshot chatContentList;

  @override
  void initState() {
    super.initState();

    getChatContent();
  }

  Future<QuerySnapshot> getChatContent() async {
    CollectionReference post = firestoreInstance.collection("post");
    post
        .where('__name__', isGreaterThanOrEqualTo: "1")
        .get()
        .then((data) => print(data.docs[0].data().toString()));

    CollectionReference comment =
        firestoreInstance.collection("post/1/comment");
    return comment.get();
  }

  Future<void> sendTextMessage(String text) {}

  Future<void> sendPhotoMessage(Uint8List photo) {}

  Future<void> sendVoiceMessage(String voicePath) {}

  Future<void> sendFileMessage(Uint8List file) {}

  void chatListPush(int type,
      {String text, Uint8List photo, String voicePath, Uint8List file}) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            CircleIcon(url: "https://i.imgur.com/BoN9kdC.png"),
            Container(padding: EdgeInsets.only(left: 15)),
            Text(widget.uid)
          ]),
          actions: [
            IconButton(
              icon: Icon(Icons.phone),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.video_call),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.only(
              left: (MediaQuery.of(context).size.width >= 1080.0)
                  ? (MediaQuery.of(context).size.width) * 0.25
                  : (MediaQuery.of(context).size.width) * 0.0,
              right: (MediaQuery.of(context).size.width >= 1080.0)
                  ? (MediaQuery.of(context).size.width) * 0.25
                  : (MediaQuery.of(context).size.width) * 0.0,
            ),
            child: Column(children: [
              Expanded(
                  flex: 9,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [for (var i in test) TestBubble(context)],
                    ),
                  )),
              Divider(
                thickness: 3.0,
                color: Colors.greenAccent[400],
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 8,
                            child: TextField(
                              maxLines: 999,
                            )),
                        Expanded(
                            child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {},
                        ))
                      ],
                    ),
                  ))
            ])));
  }
}

Widget TestBubble(BuildContext context) {
  return Column(
    children: [
      ChatBubble(
        clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 20),
        backGroundColor: Colors.blue,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      ChatBubble(
        clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
        backGroundColor: Color(0xffE7E7ED),
        margin: EdgeInsets.only(top: 20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat",
            style: TextStyle(color: Colors.black),
          ),
        ),
      )
    ],
  );
}

/*
Row(children: [
CircleIcon(url: "https://i.imgur.com/BoN9kdC.png"),
Text(" Dick")
])*/

/*
Row(children: [
            CircleIcon(url: "https://i.imgur.com/BoN9kdC.png"),
            Container(padding: EdgeInsets.only(left: 15)),
            Text("Dick")
          ])
*/
