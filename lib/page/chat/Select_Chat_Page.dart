import 'package:flutter/material.dart';
import '../../component/Circle_Icon.dart';
import 'Chat_Page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import '../../firebase/Firebase_User_Data_Agent.dart';
import 'Create_New_Chat.dart';
import 'dart:convert';

class SelectChatPage extends StatelessWidget {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  FirebaseUserDataAgent firebaseUserDataAgent = FirebaseUserDataAgent();

  Future<List<QueryDocumentSnapshot>> getChatList(BuildContext context) async {
    CollectionReference chatroom = firestoreInstance.collection("chatroom");

    List<QueryDocumentSnapshot> chatList;
    await chatroom
        .where(
            'UID.' +
                Provider.of<LoginStateNotifier>(context, listen: true).getUID(),
            isEqualTo: true)
        .get()
        .then((data) => chatList = data.docs);

    return chatList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateNewChatPage()),
                  );
                })
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
            child: FutureBuilder(
                future: getChatList(context),
                builder: (BuildContext context,
                    AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text("Error");
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var i in snapshot.data)
                              FutureBuilder(
                                  future: (i
                                              .data()['UID']
                                              .toString()
                                              .substring(1, 29) ==
                                          Provider.of<LoginStateNotifier>(
                                                  context,
                                                  listen: false)
                                              .getUID())
                                      ? firebaseUserDataAgent.getDisplayName(i
                                          .data()['UID']
                                          .toString()
                                          .substring(37, 65))
                                      : firebaseUserDataAgent.getDisplayName(i
                                          .data()['UID']
                                          .toString()
                                          .substring(1, 29)),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshotDisplayName) {
                                    if (snapshotDisplayName.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshotDisplayName.hasError) {
                                        return Text("Error");
                                      } else {
                                        print(i
                                                .data()['UID']
                                                .toString()
                                                .substring(1, 29) +
                                            " " +
                                            (firebaseUserDataAgent
                                                        .getDisplayName(i
                                                            .data()['UID']
                                                            .toString()
                                                            .substring(
                                                                1, 29)) ==
                                                    Provider.of<LoginStateNotifier>(
                                                            context,
                                                            listen: false)
                                                        .getUID())
                                                .toString());
                                        print(i
                                                .data()['UID']
                                                .toString()
                                                .substring(37, 65) +
                                            " " +
                                            (firebaseUserDataAgent
                                                        .getDisplayName(i
                                                            .data()['UID']
                                                            .toString()
                                                            .substring(
                                                                37, 65)) ==
                                                    Provider.of<LoginStateNotifier>(
                                                            context,
                                                            listen: false)
                                                        .getUID())
                                                .toString());

                                        return ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatPage(
                                                        uid: i.id,
                                                        displayName:
                                                            snapshotDisplayName
                                                                .data,
                                                        chatDocumentID: i.id,
                                                      )),
                                            );
                                          },
                                          dense: false,
                                          leading: FutureBuilder(
                                            future: (i
                                                .data()['UID']
                                                .toString()
                                                .substring(1, 29) ==
                                                Provider.of<LoginStateNotifier>(
                                                    context,
                                                    listen: false)
                                                    .getUID()) ? firebaseUserDataAgent.getUserIconURL(i
                                                .data()['UID']
                                                .toString()
                                                .substring(37, 65)): firebaseUserDataAgent.getUserIconURL(i
                                                .data()['UID']
                                                .toString()
                                                .substring(1, 29)),
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
                                                          image: AssetImage('photo/emptyusericon.png'))),
                                                );
                                              }
                                            },
                                          ),
                                          title: Text(snapshotDisplayName.data),
                                          subtitle: Text(""),
                                        );
                                      }
                                    } else {
                                      return Container();
                                    }
                                  })
                          ],
                        ),
                      );
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                })));
  }
}
