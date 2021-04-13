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
import '../chat/Chat_Page.dart';

class ProfilePage extends StatelessWidget {
  String UID;

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  FirebaseUserDataAgent firebaseUserDataAgent = FirebaseUserDataAgent();

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
              print("Target UID: " + UID + " Own UID: " +   Provider.of<LoginStateNotifier>(context,
                  listen: false)
                  .getUID());
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
                                leading: FutureBuilder(
                                  future: userAgent.getUserIconURL(UID),
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
                                                image: AssetImage(
                                                    'assets/photo/emptyusericon.jpg'))),
                                      );
                                    }
                                  },
                                ),
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
                              : RaisedButton(
                                  onPressed: () async {
                                    CollectionReference chatroom =
                                        firestoreInstance
                                            .collection("chatroom");

                                    int chatRoomFound = 0;

                                    List<QueryDocumentSnapshot> data;

                                    await chatroom
                                        .where(
                                            'UID.' +
                                                Provider.of<LoginStateNotifier>(
                                                        context,
                                                        listen: false)
                                                    .getUID(),
                                            isEqualTo: true)
                                        .get()
                                        .then((value) => data = value.docs);

                                    chatRoomFound = data.length;

                                    if (chatRoomFound == 0) {
                                      chatroom.add({
                                        'UID': {
                                          Provider.of<LoginStateNotifier>(
                                                  context,
                                                  listen: false)
                                              .getUID(): true,
                                          UID: true
                                        }
                                      }).then((value) =>
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ChatPage(
                                                      uid: UID,
                                                      displayName:
                                                          snapshot.data.data()[
                                                              'displayName'],
                                                      chatDocumentID: value.id,
                                                    )),
                                          ));
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                  uid: UID,
                                                  displayName: snapshot.data
                                                      .data()['displayName'],
                                                  chatDocumentID: data[0].id,
                                                )),
                                      );
                                    }
                                  },
                                  child: Text("Chat"),
                                ),
                          FutureBuilder(
                              future: Future.wait([
                                firebaseUserDataAgent.isFriend(
                                    Provider.of<LoginStateNotifier>(context,
                                            listen: false)
                                        .getUID(),
                                    UID)
                              ]),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  //print("is Wait For Accept" + snapshot.data[1].toString());
                                  if (snapshot.data[0] == true) {
                                    return Container();
                                  } else {
                                    return FutureBuilder(
                                        future: firebaseUserDataAgent
                                            .isWaitForAccept(
                                                Provider.of<LoginStateNotifier>(
                                                        context,
                                                        listen: false)
                                                    .getUID(),
                                                UID),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            if (snapshot.data == true) {
                                              return RaisedButton(
                                                child: Text("Wait For Accept"),
                                                onPressed: () {
                                                  firestoreInstance
                                                      .collection("groupDB/" +
                                                          Provider.of<LoginStateNotifier>(
                                                                  context,
                                                                  listen: false)
                                                              .getUID() +
                                                          "/groups")
                                                      .doc(
                                                          "waitForTargetUserAccept")
                                                      .update({
                                                    'UID.' + UID:
                                                        FieldValue.delete()
                                                  });

                                                  firestoreInstance
                                                      .collection("groupDB/" +
                                                          UID +
                                                          "/groups")
                                                      .doc("waitForAccept")
                                                      .update({
                                                    'UID.' +
                                                        Provider.of<LoginStateNotifier>(
                                                                context,
                                                                listen: false)
                                                            .getUID(): FieldValue
                                                        .delete()
                                                  });
                                                },
                                              );
                                            } else {
                                              return (UID == Provider.of<LoginStateNotifier>(context,
                                                  listen: false)
                                                  .getUID()) ? Container() : RaisedButton(
                                                child: Text("Add Friends"),
                                                onPressed: () {
                                                  firestoreInstance
                                                      .collection("groupDB/" +
                                                      Provider.of<LoginStateNotifier>(
                                                          context,
                                                          listen: false)
                                                          .getUID() +
                                                      "/groups")
                                                      .doc(
                                                      "waitForTargetUserAccept")
                                                      .update(
                                                      {'UID.' + UID: true});

                                                  firestoreInstance
                                                      .collection("groupDB/" +
                                                      UID +
                                                      "/groups")
                                                      .doc("waitForAccept")
                                                      .update({
                                                    'UID.' +
                                                        Provider.of<LoginStateNotifier>(
                                                            context,
                                                            listen: false)
                                                            .getUID(): true
                                                  });
                                                },
                                              );
                                            }
                                          } else {
                                            return Container();
                                          }
                                        });
                                  }
                                } else {
                                  return Container();
                                }
                              })
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
                                      postDate: i.data()['postTime'],
                                      postID: i.id,
                                      description: i.data()['description'],
                                      videoMode: i.data()['video'],
                                    ),
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
