import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../component/Post_View.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

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
  FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<dynamic> getPost() async {


    dynamic postList;

    /*
    CollectionReference post = firestoreInstance.collection("post");
    await post
        .orderBy("postTime", descending: true)
        .get()
        .then((data) => postList = data.docs);*/

    postList = await functions.httpsCallable('getPostList').call();

    print("canComment: " + postList.data[0]['canComment'].toString());

    return postList;

  }

    @override
    Widget build(BuildContext context) {
      return FutureBuilder(
          future: getPost(),
          builder: (BuildContext context,
              AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return RefreshIndicator(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var i in snapshot.data.data)
                          PostView(
                            username: i['UID'],
                            postDate: Timestamp(i['postTimeSeconds'], i['postTimeNanoseconds']),
                            //postDate: Timestamp(i['postTime']['_seconds'], i['postTime']['_nanoseconds']),
                            postID: i['postID'],
                            description: i['description'],
                            videoMode: i['video'],
                          canComment: i['canComment'])
                      ],
                    ),
                  ),
                  onRefresh: (){
                    setState(() {

                    });
                  },
                );
              }
            } else {
              return Center(child: CircularProgressIndicator(),);
            }
          });
    }
}
