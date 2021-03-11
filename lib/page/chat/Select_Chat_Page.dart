import 'package:flutter/material.dart';
import '../../component/Circle_Icon.dart';
import 'Chat_Page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectChatPage extends StatefulWidget {
  @override
  _SelectChatPageState createState() => _SelectChatPageState();
}

class _SelectChatPageState extends State<SelectChatPage> {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  QuerySnapshot chatList;

  @override
  void initState() {
    super.initState();

    getChatList();
  }

  Future<QuerySnapshot> getChatList() async {
    CollectionReference post = firestoreInstance.collection("post");
    post
        .where('__name__', isGreaterThanOrEqualTo: "1")
        .get()
        .then((data) => print(data.docs[0].data().toString()));

    CollectionReference comment =
        firestoreInstance.collection("post/1/comment");
    return comment.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Chat")),
        body: Container(
            padding: EdgeInsets.only(
              left: (MediaQuery.of(context).size.width >= 1080.0)
                  ? (MediaQuery.of(context).size.width) * 0.25
                  : (MediaQuery.of(context).size.width) * 0.0,
              right: (MediaQuery.of(context).size.width >= 1080.0)
                  ? (MediaQuery.of(context).size.width) * 0.25
                  : (MediaQuery.of(context).size.width) * 0.0,
            ),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                                uid: "test",
                              )),
                    );
                  },
                  dense: true,
                  leading: CircleIcon(url: "https://i.imgur.com/BoN9kdC.png"),
                  title: Text("Handsome"),
                  subtitle: Text("I am handsome"),
                ),
                Divider(
                  color: Colors.greenAccent[400],
                ),
                ListTile(
                  dense: true,
                  leading: CircleIcon(
                      url:
                          "https://startupbeat.hkej.com/wp-content/uploads/2016/05/Instagram-ICON-13MAY-768x769.png"),
                  title: Text("Not handsome"),
                  subtitle: Text("You are not handsome"),
                ),
              ],
            )));
  }
}
