import 'package:flutter/material.dart';
import '../../component/Circle_Icon.dart';
import 'Chat_Page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import '../../firebase/Firebase_User_Data_Agent.dart';

class CreateNewChatPage extends StatelessWidget {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  FirebaseUserDataAgent firebaseUserDataAgent = FirebaseUserDataAgent();

  TextEditingController targetUsername = new TextEditingController();

  Future<void> createNewChat(BuildContext context) async {
    CollectionReference chatroom = firestoreInstance.collection("chatroom");

    String targetUID, targetDisplayName;

    int chatRoomFound = 0;

    await firebaseUserDataAgent.getUIDByUsername(targetUsername.text).then((value) =>
    targetUID = value).then((value) =>
        firebaseUserDataAgent.getDisplayName(targetUID).then((value) =>
        targetDisplayName = value));

    List<QueryDocumentSnapshot> data;

    await chatroom
        .where('UID.' +
        Provider.of<LoginStateNotifier>(context, listen: false).getUID(),
        isEqualTo: true
    ).where('UID.' + targetUID, isEqualTo: true).get().then((value) => data = value.docs);

    chatRoomFound = data.length;

    if (chatRoomFound == 0) {
      chatroom.add({
        'UID': {
          Provider.of<LoginStateNotifier>(context, listen: false)
              .getUID(): true,
          targetUID: true
        }
      }).then((value) =>
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatPage(
                      uid: targetUID,
                      displayName:
                      targetDisplayName,
                      chatDocumentID: value.id,
                    )),
          ));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ChatPage(
                  uid: targetUID,
                  displayName:
                  targetDisplayName,
                  chatDocumentID: data[0].id,
                )),
      );
  }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create new chat")),
      body: Container(
          padding: EdgeInsets.only(
            left: (MediaQuery
                .of(context)
                .size
                .width >= 1080.0)
                ? (MediaQuery
                .of(context)
                .size
                .width) * 0.25
                : (MediaQuery
                .of(context)
                .size
                .width) * 0.0,
            right: (MediaQuery
                .of(context)
                .size
                .width >= 1080.0)
                ? (MediaQuery
                .of(context)
                .size
                .width) * 0.25
                : (MediaQuery
                .of(context)
                .size
                .width) * 0.0,
          ),
          child: Container(
            child: Column(
              children: [
                TextField(
                  controller: targetUsername,
                ),
                RaisedButton(onPressed: () {
                  createNewChat(context);
                }, child: Text("Create"),)
              ],
            ),
          )),
    );
  }
}
