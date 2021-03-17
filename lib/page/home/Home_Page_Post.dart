import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../component/Post_View.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../firebase/Firebase_User_Data_Agent.dart';
import '../../firebase/Firebase_Post_Data_Agent.dart';
import 'package:flutter/foundation.dart';

class HomePagePost extends StatelessWidget {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> getPost() async {
    List<QueryDocumentSnapshot> postList;
    CollectionReference post = firestoreInstance.collection("post");
    await post
        .orderBy("postID")
        .get()
        .then((data) => postList = data.docs);
    return postList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getPost(),
        builder: (BuildContext context,
            AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error");
            } else {
              return Container(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var i in snapshot.data)
                      PostView(
                          username: i.data()['UID'],
                          iconURL: "https://i.imgur.com/BoN9kdC.png",
                          postDate: i.data()['postTime'].toString(),
                          postID: i.data()['postID'],
                          description: i.data()['description'])
                  ],
                ),
              ));
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
