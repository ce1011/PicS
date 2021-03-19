import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pics/component/Circle_Icon.dart';
import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import '../../component/Circle_Icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase/Firebase_User_Data_Agent.dart';
import '../setting/Setting.dart';
import '../../component/Post_View.dart';

class HomePageProfile extends StatelessWidget {
  String UID;

  HomePageProfile({Key key, @required this.UID}) : super(key: key);

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  FirebaseUserDataAgent firebaseUserDataAgent = FirebaseUserDataAgent();

  QuerySnapshot userPostList;

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

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        FutureBuilder(
            future: getProfileInformation(
                Provider.of<LoginStateNotifier>(context, listen: false).UID),
            builder: (BuildContext context,
                AsyncSnapshot<QueryDocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text("Error");
                } else {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: ListTile(
                            leading: CircleIcon(
                                url:
                                "https://pbs.twimg.com/profile_images/1343584679664873479/Xos3xQfk_400x400.jpg"),
                            title: Text(snapshot.data['displayName']),
                            subtitle: Text(snapshot.data['username'])),
                      ),
                      ListTile(subtitle: Text(snapshot.data['description'])),
                    ],
                  );
                }
              } else {
                return CircularProgressIndicator();
              }
            }),
        Divider(
          color: Colors.greenAccent[400],
        ),
        ListTile(title: Text("Post", style: TextStyle(fontSize: 20))),
        FutureBuilder(
            future: getProfilePost(
                Provider.of<LoginStateNotifier>(context, listen: false).UID),
            builder: (BuildContext context,
                AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text("Error");
                } else {
                  return snapshot.data.isEmpty ? Text("No post"): Expanded(
                    flex: 7,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var i in snapshot.data)
                            PostView(
                                username: i.data()['UID'],
                                iconURL: "https://i.imgur.com/BoN9kdC.png",
                                postDate: i.data()['postTime'].toString(),
                                postID: i.data()['postID'].toString(),
                                description: i.data()['description']),
                          RaisedButton(
                            child: Text("Log Out"),
                            onPressed: () {
                              auth.signOut();
                              Provider.of<LoginStateNotifier>(context,
                                      listen: false)
                                  .logout();
                              Navigator.popAndPushNamed(context, "/");
                            },
                          ),
                          RaisedButton(
                            child: Text("Setting"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingPage()),
                              );
                            },
                          )
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
    ));
  }
}
