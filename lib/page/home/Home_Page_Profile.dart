import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pics/component/Circle_Icon.dart';
import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import '../../component/Circle_Icon.dart';
import '../comment/View_Comment_Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase/Firebase_User_Data_Agent.dart';
import '../../firebase/Firebase_Post_Data_Agent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../setting/Setting.dart';
import '../../component/Post_View.dart';

class HomePageProfile extends StatefulWidget {
  String UID;

  HomePageProfile({Key key, @required this.UID}) : super(key: key);

  @override
  _HomePageProfileState createState() => _HomePageProfileState();
}

class _HomePageProfileState extends State<HomePageProfile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  FirebaseUserDataAgent firebaseUserDataAgent = FirebaseUserDataAgent();
  FirebasePostDataAgent firebasePostDataAgent = FirebasePostDataAgent();

  QuerySnapshot userPostList;

  Future<QuerySnapshot> getPost(String UID) async {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: ListTile(
                      leading: CircleIcon(
                          url:
                              "https://pbs.twimg.com/profile_images/1343584679664873479/Xos3xQfk_400x400.jpg"),
                      title: Text("Google"),
                      subtitle: Text("handsome123")),
                ),
                ListTile(subtitle: Text("Lorem ipsum dolor sit amet")),
                RaisedButton(onPressed: ()async{
                  CollectionReference comment =
                  FirebaseFirestore.instance.collection('/post/1/comment');

                  String lastIndex;
                  bool success;

                  QuerySnapshot lastComment = await comment
                      .orderBy('__name__', descending: true)
                      .limit(1)
                      .get();

                  lastIndex = lastComment.docs[0].id;

                  print(lastComment.docs[0].id);

                  await comment
                      .doc(lastIndex)
                      .set({
                    'UID': "testest",
                    'commentTime': new Timestamp.now(),
                    'content': 'test',
                    'startX': 300,
                    'startY': 300,
                    'endX': 500,
                    'endY': 500
                  })
                      .then((value) => success = true)
                      .catchError((error) => success = false);

                  return success;
                }, child: Text("Create Post"),)
              ],
            )),
        Divider(
          color: Colors.greenAccent[400],
        ),
        ListTile(title: Text("Post", style: TextStyle(fontSize: 20))),
        Expanded(
          flex: 7,
          child: SingleChildScrollView(
            child: Column(
              children: [
                PostView(
                    username: "Google",
                    iconURL:
                        "https://pbs.twimg.com/profile_images/1343584679664873479/Xos3xQfk_400x400.jpg",
                    postDate: "Posted at 31 Feb 2021 23:59",
                    postID:
                        "2",
                    description:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
                PostView(
                    username: "Google",
                    iconURL:
                        "https://pbs.twimg.com/profile_images/1343584679664873479/Xos3xQfk_400x400.jpg",
                    postDate: "Posted at 31 Feb 2021 23:59",
                    postID:
                        "1",
                    description:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
                RaisedButton(
                  child: Text("Log Out"),
                  onPressed: () {
                    auth.signOut();
                    Navigator.popAndPushNamed(context, "/");
                  },
                ),
                RaisedButton(
                  child: Text("Setting"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingPage()),
                    );
                  },
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
