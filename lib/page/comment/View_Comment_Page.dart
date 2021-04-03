import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as ImageProcess;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../component/Comment_View.dart';
import '../../component/Comment_View_Video.dart';
import '../comment/Crop_Page.dart';
import '../comment/Video_Trimming_Page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ViewCommentPage extends StatelessWidget {
  String postID, imageURL, postCreatorUID, videoURL;
  bool videoMode;

  ViewCommentPage({Key key, @required this.postID, @required this.videoMode})
      : super(key: key);

  Uint8List photoByte;
  ImageProcess.Image photo;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage _storageInstance =
      firebase_storage.FirebaseStorage.instance;

  Future<List<QueryDocumentSnapshot>> getCommentData() async {
    String url, postDocumentName;
    List<QueryDocumentSnapshot> commentList, postData;

    CollectionReference post = firestoreInstance.collection("post");

    await post.where("__name__", isEqualTo: postID).get().then((data) => {
          postDocumentName = data.docs[0].id,
          postCreatorUID = data.docs[0]['UID'],
          videoMode = data.docs[0]['video']
        });

    await firestoreInstance
        .collection("post/" + postDocumentName + "/comment")
        .orderBy("commentTime")
        .get()
        .then((data) => commentList = data.docs);

    if (videoMode == false) {
      url = await _storageInstance
          .ref('/post/' + postID + '.jpg')
          .getDownloadURL();

      print(postID + videoMode.toString());

      var response = await http.get(url);
      this.photoByte = response.bodyBytes;
      this.photo = ImageProcess.decodeJpg(photoByte);
    } else {
      videoURL = await _storageInstance
          .ref('/post/' + postID + '.mp4')
          .getDownloadURL();

      print(commentList.length);
    }

    return commentList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment"),
        actions: [
          (videoMode == false)
              ? IconButton(
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
              : PopupMenuButton(
                  icon: Icon(Icons.add_comment),
                  itemBuilder: (context) {
                    var commentType = List<PopupMenuEntry<Object>>();

                    commentType
                        .add(PopupMenuItem(child: Text("Clip"), value: 1));

                    return commentType;
                  },
                  onSelected: (value) async {
                    switch (value) {
                      case 1:
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VideoTrimmingPage(
                                      url: videoURL,
                                      postID: postID,
                                    )),
                          );
                        }
                    }
                  },
                )
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(
                left: (MediaQuery.of(context).size.width >= 1080.0)
                    ? (MediaQuery.of(context).size.width) * 0.25
                    : 0,
                right: (MediaQuery.of(context).size.width >= 1080.0)
                    ? (MediaQuery.of(context).size.width) * 0.25
                    : 0,
              ),
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
                          (!videoMode)
                              ? Container(
                                  padding:
                                      EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: CommentView(
                                    username: i.data()['UID'],
                                    iconURL: "https://i.imgur.com/BoN9kdC.png",
                                    commentDate: i.data()['commentTime'],
                                    photoByte: photoByte,
                                    StartX: i.data()['startX'],
                                    StartY: i.data()['startY'],
                                    EndX: i.data()['endX'],
                                    EndY: i.data()['endY'],
                                    description: i.data()['content'],
                                    postCreatorUID: postCreatorUID,
                                    commentID: i.id,
                                    postID: postID,
                                  ))
                              : Container(
                                  padding:
                                      EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: CommentViewVideo(
                                    username: i.data()['UID'],
                                    iconURL: "https://i.imgur.com/BoN9kdC.png",
                                    commentDate: i.data()['commentTime'],
                                    description: i.data()['content'],
                                    postCreatorUID: postCreatorUID,
                                    commentID: i.id,
                                    postID: postID,
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
