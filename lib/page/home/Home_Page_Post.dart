import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../component/Post_View.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../firebase/Firebase_User_Data_Agent.dart';
import '../../firebase/Firebase_Post_Data_Agent.dart';
import 'package:flutter/foundation.dart';

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
        PostView(
            username: "Ted Chan",
            iconURL:"https://i.imgur.com/BoN9kdC.png",
            postDate:"Posted at 31 Feb 2021 23:59",
            imageURL: kIsWeb ? "https://sehh3140_pics.gitlab.io/sehh3140_frontend_page/ultraviolet-wallpaper-1280x720-wallpaper.jpg" : 'https://free4kwallpapers.com/uploads/wallpaper/ultraviolet-wallpaper-1280x720-wallpaper.jpg',
            description: "12312321312312"),
        PostView(
            username:  "Chan wai ho",
            iconURL:"https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg",
            postDate:"Posted at 25 Feb 2020 12:00",
            imageURL:kIsWeb ? "https://sehh3140_pics.gitlab.io/sehh3140_frontend_page/ultraviolet-wallpaper-1280x720-wallpaper.jpg" : 'https://free4kwallpapers.com/uploads/wallpaper/ultraviolet-wallpaper-1280x720-wallpaper.jpg',
            description: "testtesttest"),
      ],
    )));
  }
}
