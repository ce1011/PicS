import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as ImageProcess;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../component/Comment_View.dart';
import '../comment/Crop_Page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ViewCommentPage extends StatelessWidget {
  String postID, imageURL;

  ViewCommentPage({Key key, @required this.postID}) : super(key: key);

  Uint8List photoByte;
  ImageProcess.Image photo;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage _storageInstance =
      firebase_storage.FirebaseStorage.instance;

  Future<List<QueryDocumentSnapshot>> getCommentData() async {
    String url, postDocumentName;
    List<QueryDocumentSnapshot> commentList;
    url =
        await _storageInstance.ref('/post/' + postID + '.jpg').getDownloadURL();

    var response = await http.get(url);
    this.photoByte = response.bodyBytes;
    this.photo = ImageProcess.decodeJpg(photoByte);

    CollectionReference post = firestoreInstance.collection("post");

    await post
        .where("postID", isEqualTo: int.parse(postID))
        .get()
        .then((data) => {postDocumentName = data.docs[0].id});
    print("post/" + postDocumentName + "/comment");
    await firestoreInstance
        .collection("post/" + postDocumentName + "/comment")
    .orderBy("commentID")
        .get()
        .then((data) => commentList = data.docs);
    return commentList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment"),
        actions: [
          IconButton(
              icon: Icon(Icons.add_comment),
              onPressed: () {
                print(postID);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CropPage(

                            photoByte: photoByte,
                            postID: postID,
                          )),
                );
              })
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
              child: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getCommentData(),
        builder: (BuildContext context,
            AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Column(children: [
                for (var i in snapshot.data)
                  Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: CommentView(
                        username: i.data()['UID'],
                        iconURL: "https://i.imgur.com/BoN9kdC.png",
                        commentDate: i.data()['commentTime'].toString(),
                        photoByte: photoByte,
                        StartX: i.data()['startX'],
                        StartY: i.data()['startY'],
                        EndX: i.data()['endX'],
                        EndY: i.data()['endY'],
                        description: i.data()['content'],
                      )),
              ]);
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ))),
    );
  }
}
