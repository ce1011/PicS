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


class HomePageProfile extends StatelessWidget {
  String UID;
  String description;

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

    description = profileInformation.data()['description'];
    return profileInformation;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: ListTile(
                  leading: FutureBuilder(
                    future: firebaseUserDataAgent.getUserIconURL(Provider.of<LoginStateNotifier>(context, listen: false).UID),
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
                  title: Text(
                      Provider.of<LoginStateNotifier>(context, listen: true)
                          .displayName),
                  subtitle: Text(
                      Provider.of<LoginStateNotifier>(context, listen: true)
                          .username)),
            ),
            ListTile(
                subtitle: Text(
                    Provider.of<LoginStateNotifier>(context, listen: true)
                        .getDescription())), RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileEditPage()));
                },
                child: Text("Edit profile"))
          ],
        ),
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
                                      postDate: i.data()['postTime'],
                                      postID: i.id,
                                      description: i.data()['description'],
                                      videoMode: i.data()['video']),
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
