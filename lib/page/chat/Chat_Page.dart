import 'dart:io';

import 'package:flutter/material.dart';
import '../../component/Circle_Icon.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:typed_data';

class ChatPage extends StatefulWidget {
  String uid, displayName, chatDocumentID;

  ChatPage(
      {Key key,
      @required this.uid,
      @required this.displayName,
      @required this.chatDocumentID})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Uint8List _image;
  File _file;
  int lastIndex;

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storageInstance =
      firebase_storage.FirebaseStorage.instance;

  List<QueryDocumentSnapshot> chatContentList;

  TextEditingController chatTextController = new TextEditingController();

  Future<void> sendTextMessage(String text) {
    CollectionReference chatContentCollection = firestoreInstance
        .collection("chatroom/" + widget.chatDocumentID + "/chatContent");

    chatContentCollection.add({
      'chatContentID': lastIndex + 1,
      'content': chatTextController.text,
      'contentType': 0,
      'sendAt': new Timestamp.now(),
      'sendBy': Provider.of<LoginStateNotifier>(context, listen: false).getUID()
    }).then((value) => chatTextController.text = "");
  }

  Future<void> sendPhotoMessage(Uint8List photo) async {
    int temp_lastIndex;
    if (lastIndex == null) {
      temp_lastIndex = -1;
    } else {
      temp_lastIndex = lastIndex;
    }

    CollectionReference chatContentCollection = firestoreInstance
        .collection("chatroom/" + widget.chatDocumentID + "/chatContent");

    try {
      await storageInstance
          .ref('chat/' +
              widget.chatDocumentID +
              '/' +
              (temp_lastIndex + 1).toString() +
              '.jpg')
          .putData(photo);
      await chatContentCollection.add({
        'chatContentID': temp_lastIndex + 1,
        'contentType': 1,
        'sendAt': new Timestamp.now(),
        'sendBy':
            Provider.of<LoginStateNotifier>(context, listen: false).getUID()
      });
    } on FirebaseException catch (e) {
      print("Error");
    }
  }

  Future<void> sendVoiceMessage(String voicePath) {}

  Future<void> sendFileMessage(Uint8List file) {}

  void chatListPush(int type,
      {String text, Uint8List photo, String voicePath, Uint8List file}) {}

  Widget chatBubbleContent(int type, {String content, int chatContentID}) {
    switch (type) {
      case 0:
        {
          return Text(content);
        }
      case 1:
        {
          return FutureBuilder(
              future: getChatImageURL(chatContentID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.network(snapshot.data);
                } else {
                  return Container();
                }
              });
        }
    }
  }

  Future<String> getChatImageURL(int chatContentID) async {
    String url;
    url = await storageInstance
        .ref('chat/' +
            widget.chatDocumentID +
            '/' +
            chatContentID.toString() +
            '.jpg')
        .getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            CircleIcon(url: "https://i.imgur.com/BoN9kdC.png"),
            Container(padding: EdgeInsets.only(left: 15)),
            Text(widget.displayName)
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
                      child: StreamBuilder<QuerySnapshot>(
                          stream: firestoreInstance
                              .collection("chatroom/" +
                                  widget.chatDocumentID +
                                  "/chatContent")
                              .orderBy('sendAt')
                              .limitToLast(15)
                              .snapshots(),
                          builder: (context, snapshot) {
                            lastIndex =
                                snapshot.data.docs.last.data()['chatContentID'];
                            return snapshot.hasData
                                ? Column(
                                    children: [
                                      for (var i in snapshot.data.docs)
                                        ChatBubble(
                                            clipper: (i.data()['sendBy'] ==
                                                    Provider.of<LoginStateNotifier>(context, listen: false)
                                                        .getUID())
                                                ? ChatBubbleClipper1(
                                                    type: BubbleType.sendBubble)
                                                : ChatBubbleClipper1(
                                                    type: BubbleType
                                                        .receiverBubble),
                                            alignment: (i.data()['sendBy'] ==
                                                    Provider.of<LoginStateNotifier>(
                                                            context,
                                                            listen: false)
                                                        .getUID())
                                                ? Alignment.topRight
                                                : Alignment.topLeft,
                                            margin: EdgeInsets.only(top: 20),
                                            backGroundColor: (i.data()['sendBy'] ==
                                                    Provider.of<LoginStateNotifier>(
                                                            context,
                                                            listen: false)
                                                        .getUID())
                                                ? Colors.blue
                                                : Colors.purple,
                                            child: Container(
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                              ),
                                              child: chatBubbleContent(
                                                i.data()['contentType'],
                                                content: i.data()['content'],
                                                chatContentID:
                                                    i.data()['chatContentID'],
                                              ),
                                            )),
                                    ],
                                  )
                                : Container();
                          }))),
              Divider(
                thickness: 3.0,
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 8,
                            child: TextField(
                              controller: chatTextController,
                              maxLines: 999,
                            )),
                        Expanded(
                            child: PopupMenuButton(
                          icon: Icon(Icons.attach_file),
                          itemBuilder: (context) {
                            var messageType = List<PopupMenuEntry<Object>>();
                            messageType.add(PopupMenuItem(
                              child: Text("Photo/Video"),
                              value: 1,
                            ));
                            messageType.add(PopupMenuItem(
                              child: Text("File"),
                              value: 2,
                            ));
                            return messageType;
                          },
                          onSelected: (value) async {
                            switch (value) {
                              case 1:
                                {
                                  print("ok");
                                  FilePickerResult result =
                                      await FilePicker.platform.pickFiles(
                                          type: FileType.image, withData: true);

                                  setState(() {
                                    if (result != null) {
                                      PlatformFile file = result.files.first;
                                      sendPhotoMessage(file.bytes);
                                    } else {
                                      print('No image selected.');
                                    }
                                  });

                                  break;
                                }

                              case 2:
                                {
                                  print("ok2");
                                }
                            }
                          },
                        )),
                        Expanded(
                            child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            sendTextMessage(chatTextController.text);
                          },
                        ))
                      ],
                    ),
                  ))
            ])));
  }
}
