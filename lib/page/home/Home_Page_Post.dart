import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../component/Circle_Icon.dart';
import '../comment/View_Comment_Page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../firebase/Firebase_User_Data_Agent.dart';
import '../../firebase/Firebase_Post_Data_Agent.dart';

class HomePagePost extends StatefulWidget {
  @override
  _HomePagePostState createState() => _HomePagePostState();
}

class _HomePagePostState extends State<HomePagePost> {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  FirebaseUserDataAgent firebaseUserDataAgent = FirebaseUserDataAgent();
  FirebasePostDataAgent firebasePostDataAgent = FirebasePostDataAgent();

  QuerySnapshot postList;

  @override
  void initState() {
    super.initState();

    getPost();
  }

  Future<String> getPostImageURL(String postID) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('users/123/avatar.jpg')
        .getDownloadURL();
    return downloadURL;
    // Within your widgets:
    // Image.network(downloadURL);
  }

  Future<QuerySnapshot> getPost() async {
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
    return Container(
        child: SingleChildScrollView(
            child: Column(
      children: [
        Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  leading:
                      CircleIcon(url: "https://i.imgur.com/BoN9kdC.png"),
                  title: Text("Ted Chan"),
                  subtitle: Text("Posted at 31 Feb 2021 23:59"),
                ),
                Divider(
                ),
                Container(
                    child: Image.network(
                        "https://free4kwallpapers.com/uploads/wallpaper/ultraviolet-wallpaper-1280x720-wallpaper.jpg")),
                Container(
                  padding:
                      EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                  child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
                ),
                Divider(),
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
            )),
        Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  leading: CircleIcon(
                      url:
                          "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg"),
                  title: Text("Chan wai ho"),
                  subtitle: Text("Posted at 25 Feb 2020 12:00"),
                ),
                Divider(
                ),
                Container(
                    child: Image.network(
                        "https://cdn.wallpaperhub.app/cloudcache/1/b/5/8/e/f/1b58ef6e3d36a42e01992accf5c52d6eea244353.jpg")),
                Container(
                  padding:
                      EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                  child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
                ),
                Divider(
                ),
                Container(
                    child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.favorite)),
                    IconButton(icon: Icon(Icons.comment)),
                    IconButton(icon: Icon(Icons.forward)),
                  ],
                ))
              ],
            ))
      ],
    )));
  }
}
