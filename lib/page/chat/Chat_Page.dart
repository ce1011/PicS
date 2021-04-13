import 'dart:io';

import 'package:flutter/foundation.dart';
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
import 'package:link/link.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import '../../firebase/Firebase_User_Data_Agent.dart';

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
  String voiceFile = "temp.aac";

  FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();

  bool _myPlayerInit = false;
  bool _myRecorderInit = false;

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storageInstance =
      firebase_storage.FirebaseStorage.instance;

  FirebaseUserDataAgent firebaseUserDataAgent = FirebaseUserDataAgent();

  List<QueryDocumentSnapshot> chatContentList;

  TextEditingController chatTextController = new TextEditingController();

  Future<void> sendTextMessage(String text) {
    int temp_lastIndex;
    CollectionReference chatContentCollection = firestoreInstance
        .collection("chatroom/" + widget.chatDocumentID + "/chatContent");

    if (lastIndex == null) {
      temp_lastIndex = -1;
    } else {
      temp_lastIndex = lastIndex;
    }

    chatContentCollection.add({
      'chatContentID': temp_lastIndex + 1,
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
    print('chat/' +
        widget.chatDocumentID +
        '/' +
        (temp_lastIndex + 1).toString() +
        '.jpg');
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

  Future<void> sendVoiceMessage(String voicePath) async {
    File file = File(voicePath);

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
              '.aac')
          .putFile(file);
      await chatContentCollection.add({
        'chatContentID': temp_lastIndex + 1,
        'contentType': 3,
        'sendAt': new Timestamp.now(),
        'sendBy':
            Provider.of<LoginStateNotifier>(context, listen: false).getUID()
      });
    } on FirebaseException catch (e) {
      print("Error");
    }
  }

  Future<void> sendFileMessage(Uint8List file, String filename) async {
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
              '/' +
              filename)
          .putData(file);
      await chatContentCollection.add({
        'chatContentID': temp_lastIndex + 1,
        'contentType': 2,
        'content': filename,
        'sendAt': new Timestamp.now(),
        'sendBy':
            Provider.of<LoginStateNotifier>(context, listen: false).getUID()
      });
    } on FirebaseException catch (e) {
      print("Error");
    }
  }

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
      case 2:
        {
          return FutureBuilder(
              future: getChatFileURL(content, chatContentID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Link(
                    child: Text(snapshot.data),
                    url: snapshot.data,
                  );
                } else {
                  return Container();
                }
              });
        }
      case 3:
        {
          return FutureBuilder(
              future: getChatAudioURL(chatContentID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SoundPlayerUI.fromTrack(
                    Track(
                      trackPath: snapshot.data,
                      codec: Codec.aacADTS,
                    ),
                  );
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

  Future<String> getChatFileURL(String filename, int chatContentID) async {
    String url;
    url = await storageInstance
        .ref('chat/' +
            widget.chatDocumentID +
            '/' +
            chatContentID.toString() +
            '/' +
            filename)
        .getDownloadURL();
    return url;
  }

  Future<String> getChatAudioURL(int chatContentID) async {
    String url;
    url = await storageInstance
        .ref('chat/' +
            widget.chatDocumentID +
            '/' +
            chatContentID.toString() +
            '.aac')
        .getDownloadURL();
    return url;
  }

  @override
  void initState() {
    super.initState();
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    _myPlayer.openAudioSession().then((value) {
      setState(() {
        _myPlayerInit = true;
      });
    });

    _myRecorder.openAudioSession().then((value) {
      setState(() {
        _myRecorderInit = true;
      });
    });
  }

  @override
  void dispose() {
    // Be careful : you must `close` the audio session when you have finished with it.
    _myRecorder.closeAudioSession();
    _myRecorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            FutureBuilder(
              future: firebaseUserDataAgent.getUserIconURL(widget.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CircleIcon(url: snapshot.data);
                } else {
                  return Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/photo/emptyusericon.jpg'))),
                  );
                  return Container();
                }
              },
            ),
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
                            return (snapshot.hasData && snapshot.data.size != 0)
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
                          flex: 1,
                          child: GestureDetector(
                              onLongPress: () async {
                                await _myRecorder.startRecorder(
                                  toFile: voiceFile,
                                  codec: Codec.aacADTS,
                                );
                                print("Long");
                              },
                              onLongPressUp: () async {
                                await _myRecorder.stopRecorder();

                                _myRecorder
                                    .getRecordURL(path: "temp.aac")
                                    .then((value) => sendVoiceMessage(value));
                              },
                              child: Icon(Icons.record_voice_over)),
                        ),
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
                                  FilePickerResult result =
                                      await FilePicker.platform.pickFiles(
                                          type: FileType.any, withData: true);

                                  setState(() {
                                    if (result != null) {
                                      PlatformFile file = result.files.first;
                                      sendFileMessage(file.bytes, file.name);
                                    } else {
                                      print('No image selected.');
                                    }
                                  });

                                  break;
                                }
                            }
                          },
                        )),
                        Expanded(
                            child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            print("Text send Click");
                            sendTextMessage(chatTextController.text);
                          },
                        ))
                      ],
                    ),
                  ))
            ])));
  }
}
