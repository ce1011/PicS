import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pics/component/Circle_Icon.dart';
import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import '../../component/Circle_Icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase/Firebase_User_Data_Agent.dart';
import '../../component/Post_View.dart';
import '../profile/Profile_Edit_Page.dart';

class ProfilePage extends StatelessWidget {
  String UID;

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  ProfilePage({Key key, @required this.UID}) : super(key: key);

  Future<List<QueryDocumentSnapshot>> getProfilePost(String UID) async {
    List<QueryDocumentSnapshot> profilePostList;
    CollectionReference post = firestoreInstance.collection("post");
    await post
        .where('UID', isEqualTo: UID)
        .get()
        .then((data) => profilePostList = data.docs);
    return profilePostList;
  }

  Future<QueryDocumentSnapshot> getProfileInformation(String UID) async {
    QueryDocumentSnapshot profileInformation;

    CollectionReference profile = firestoreInstance.collection("user");

    await profile
        .where('UID', isEqualTo: UID)
        .get()
        .then((data) => profileInformation = data.docs[0]);

    return profileInformation;
  }

  FirebaseUserDataAgent userAgent = new FirebaseUserDataAgent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: userAgent.getUserName(UID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data);
            } else {
              return Text("");
            }
          },
        ),
      ),
      body: Container(
          child: Column(
        children: [
          FutureBuilder(
              future: getProfileInformation(UID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10.0),
                            child: ListTile(
                                leading: CircleIcon(
                                    url:
                                        "https://pbs.twimg.com/profile_images/1343584679664873479/Xos3xQfk_400x400.jpg"),
                                title:
                                    Text(snapshot.data.data()['displayName']),
                                subtitle:
                                    Text(snapshot.data.data()['username'])),
                          ),
                          ListTile(
                              subtitle:
                                  Text(snapshot.data.data()['description'])),
                          (UID ==
                                  Provider.of<LoginStateNotifier>(context,
                                          listen: false)
                                      .getUID())
                              ? RaisedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileEditPage()));
                                  },
                                  child: Text("Edit profile"))
                              : Container()
                        ],
                      ));
                } else {
                  return Container();
                }
              }),
          Divider(
            color: Colors.greenAccent[400],
          ),
          ListTile(title: Text("Post", style: TextStyle(fontSize: 20))),
          FutureBuilder(
              future: getProfilePost(UID),
              builder: (BuildContext context,
                  AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text("Error");
                  } else {
                    return snapshot.data.isEmpty
                        ? Text("No post")
                        : Expanded(
                            flex: 7,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (var i in snapshot.data)
                                    PostView(
                                        username: i.data()['UID'],
                                        iconURL:
                                            "https://i.imgur.com/BoN9kdC.png",
                                        postDate: i.data()['postTime'],
                                        postID: i.data()['postID'].toString(),
                                        description: i.data()['description']),
                                ],
                              ),
                            ),
                          );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      )),
    );
  }
}
