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
                              "https://scontent-hkt1-2.xx.fbcdn.net/v/t1.0-9/21751306_10155724905022838_7192191338970086519_n.png?_nc_cat=1&ccb=3&_nc_sid=09cbfe&_nc_ohc=dSF7_T0ltTgAX-Rcviu&_nc_ht=scontent-hkt1-2.xx&oh=33123f645ebd2f4a119728e88668052e&oe=604ED8D9"),
                      title: Text("Google"),
                      subtitle: Text("handsome123")),
                ),
                ListTile(subtitle: Text("Lorem ipsum dolor sit amet"))
              ],
            )),
        Divider(
          color: Colors.greenAccent[400],
        ),
        Row(children: [
          Text(
            "Post",
            style: TextStyle(fontSize: 20),
          )
        ]),
        Expanded(
          flex: 7,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    ListTile(
                      dense: true,
                      leading: CircleIcon(
                          url:
                              "https://scontent-hkt1-2.xx.fbcdn.net/v/t1.0-9/21751306_10155724905022838_7192191338970086519_n.png?_nc_cat=1&ccb=3&_nc_sid=09cbfe&_nc_ohc=dSF7_T0ltTgAX-Rcviu&_nc_ht=scontent-hkt1-2.xx&oh=33123f645ebd2f4a119728e88668052e&oe=604ED8D9"),
                      title: Text("Google"),
                      subtitle: Text("Posted at 31 Feb 2021 23:59"),
                    ),
                    Divider(
                      color: Colors.greenAccent[400],
                    ),
                    Container(
                        child: Image.network(
                            "https://res.allmacwallpaper.com/pic/Thumbnails/3645_728.jpg")),
                    Container(
                      padding: EdgeInsets.only(
                          left: 20.0, top: 10.0, right: 20.0),
                      child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
                    ),
                    Divider(
                      color: Colors.greenAccent[400],
                    ),
                    Container(
                        child: Row(
                      children: [
                        IconButton(icon: Icon(Icons.favorite)),
                        IconButton(
                          icon: Icon(Icons.comment),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewCommentPage()),
                            );
                          },
                        ),
                        IconButton(icon: Icon(Icons.forward)),
                      ],
                    ))
                  ],
                ),
                Column(
                  children: [
                    ListTile(
                      dense: true,
                      leading: CircleIcon(
                          url:
                              "https://scontent-hkt1-2.xx.fbcdn.net/v/t1.0-9/21751306_10155724905022838_7192191338970086519_n.png?_nc_cat=1&ccb=3&_nc_sid=09cbfe&_nc_ohc=dSF7_T0ltTgAX-Rcviu&_nc_ht=scontent-hkt1-2.xx&oh=33123f645ebd2f4a119728e88668052e&oe=604ED8D9"),
                      title: Text("Google"),
                      subtitle: Text("Posted at 31 Feb 2021 23:59"),
                    ),
                    Divider(
                      color: Colors.greenAccent[400],
                    ),
                    Container(
                        child: Image.network(
                            "https://i1.wp.com/9to5mac.com/wp-content/uploads/sites/6/2020/01/Every-Mac-wallpaper.jpeg?w=2000&quality=82&strip=all&ssl=1")),
                    Container(
                      padding: EdgeInsets.only(
                          left: 20.0, top: 10.0, right: 20.0),
                      child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
                    ),
                    Divider(
                      color: Colors.greenAccent[400],
                    ),
                    Container(
                        child: Row(
                      children: [
                        IconButton(icon: Icon(Icons.favorite)),
                        IconButton(
                          icon: Icon(Icons.comment),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewCommentPage()),
                            );
                          },
                        ),
                        IconButton(icon: Icon(Icons.forward)),
                      ],
                    ))
                  ],
                ),
                RaisedButton(
                  child: Text("Log Out"),
                  onPressed: () {
                    auth.signOut();
                    Navigator.popAndPushNamed(context, "/login");
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
