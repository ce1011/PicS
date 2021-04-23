import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as ImageProcess;
import 'package:pics/page/comment/View_Comment_Page.dart';
import '../../component/Comment_Crop_Photo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';

class CommentCropPartPage extends StatelessWidget {
  final Uint8List photoByte;
  int StartX, StartY, EndX, EndY;
  String postID;

  final TextEditingController commentInputController =
      new TextEditingController();

  CommentCropPartPage(
      {this.photoByte,
      this.StartX,
      this.StartY,
      this.EndX,
      this.EndY,
      this.postID});

  Future<bool> postComment(String UID) async {
    String postDocumentName;
    CollectionReference post = FirebaseFirestore.instance.collection("post");


    CollectionReference comment =
    FirebaseFirestore.instance.collection('/post/'+postID+'/comment');

    int lastIndex;
    bool success;

    QuerySnapshot lastComment = await comment
        .orderBy('commentID', descending: true)
        .limit(1)
        .get();
    if(lastComment.docs.isEmpty){
lastIndex = -1;
    }else{
      lastIndex = lastComment.docs[0].data()['commentID'];
    }

    await comment
        .add({
      'commentID': lastIndex+1,
      'UID': UID,
      'commentTime': new Timestamp.now(),
      'content': commentInputController.text,
      'startX': StartX,
      'startY': StartY,
      'endX': EndX,
      'endY': EndY
    })
        .then((value) => success = true)
        .catchError((error) => success = false);

    return success;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crop Comment"),
        actions: [
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                if (await postComment(Provider.of<LoginStateNotifier>(context, listen: false).UID) == true) {
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 2;
                  });
                  Navigator.pushNamed(
                      context, "/post/${postID}/comment", arguments: CommentArguments(true));
                } else {
                  print("error");
                }
              })
        ],
      ),
      body: Container(
          padding: EdgeInsets.only(
            left: (MediaQuery.of(context).size.width >= 1080.0)
                ? (MediaQuery.of(context).size.width) * 0.25
                : (MediaQuery.of(context).size.width) * 0.04,
            right: (MediaQuery.of(context).size.width >= 1080.0)
                ? (MediaQuery.of(context).size.width) * 0.25
                : (MediaQuery.of(context).size.width) * 0.04,
          ),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CommentCropPhoto(
                  photoByte,
                  StartX: StartX,
                  StartY: StartY,
                  EndX: EndX,
                  EndY: EndY,
                ),
              ),
              Container(
                  child: Card(
                      child: Container(
                padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                child: Column(children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Type your comment...',
                    ),
                    controller: commentInputController,
                    minLines: 6,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  )
                ]),
              )))
            ],
          )),
    );
  }
}
