import 'package:flutter/material.dart';
import 'Circle_Icon.dart';
import 'Comment_Crop_Photo.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase/Firebase_User_Data_Agent.dart';
import '../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';

class CommentView extends StatefulWidget {
  String username, iconURL, description, postCreatorUID, commentID, postID;
  Timestamp commentDate;
  int StartX, StartY, EndX, EndY;
  Uint8List photoByte;

  CommentView(
      {@required username, @required String iconURL, @required Timestamp commentDate, @required Uint8List photoByte, @required int StartX, @required int StartY, @required int EndX, @required int EndY, @required String description, @required String postCreatorUID, @required String commentID, @required postID}) {
    this.username = username;
    this.iconURL = iconURL;
    this.commentDate = commentDate;
    this.photoByte = photoByte;
    this.description = description;
    this.StartX = StartX;
    this.StartY = StartY;
    this.EndX = EndX;
    this.EndY = EndY;
    this.postCreatorUID = postCreatorUID;
    this.commentID = commentID;
    this.postID = postID;
  }

  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  FirebaseUserDataAgent userAgent = new FirebaseUserDataAgent();

  bool deleted = false;

  @override
  Widget build(BuildContext context) {
    return !deleted ? Column(
      children: [
        ListTile(
          dense: true,
          leading: InkWell(
            child: CircleIcon(url: widget.iconURL),
            onTap: () {
              Navigator.pushNamed(
                  context, "profile/" + widget.username);
            },
          ),
          title: FutureBuilder(
            future: userAgent.getDisplayName(widget.username),
            builder: (BuildContext context,
                AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text("Error");
                } else {
                  return Text(snapshot.data);
                }
              } else {
                return Text(" ");
              }
            },
          ),
          subtitle: Text("Comment at " + DateTime.fromMillisecondsSinceEpoch(
              widget.commentDate.millisecondsSinceEpoch).toLocal()
              .toString()
              .substring(0, 19)),
        ),
        Divider(
          color: Colors.greenAccent[400],
        ),
        Container(
            child:
            CommentCropPhoto(widget.photoByte,
                StartX: widget.StartX,
                StartY: widget.StartY,
                EndX: widget.EndX,
                EndY: widget.EndY)),
        Container(
          padding: EdgeInsets.only(
              left: 20.0, top: 10.0, right: 20.0),
          child: Text(
              widget.description),
        ),
        Divider(
          color: Colors.greenAccent[400],
        ),
        Container(
            child: Row(
                children: [
            ((widget.username ==
            Provider.of<LoginStateNotifier>(context,
                listen: false)
                .getUID()) || (widget.postCreatorUID ==
            Provider.of<LoginStateNotifier>(context,
                listen: false).getUID()) ? IconButton(
          icon: Icon(Icons.delete), onPressed: () {
              CollectionReference post = FirebaseFirestore
                  .instance
                  .collection("post/" + widget.postID + "/comment");

              final snackBar = SnackBar(
                content: Text("Comment Deleted"),
                behavior: SnackBarBehavior.floating,
                duration: Duration(
                    seconds: 1, milliseconds: 500),
              );

              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                          "Are you sure to delete comment?"),
                      content: Text(
                          "This action is unrevertible"),
                      actions: [
                        TextButton(
                          child: Text("Delete"),
                          onPressed: () async {
                            await post
                                .doc(widget.commentID)
                                .delete()
                                .then((value) =>
                                ScaffoldMessenger.of(
                                    context)
                                    .showSnackBar(
                                    snackBar));

                            setState(() {
                              deleted = true;
                            });

                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            },) : Container()),
      ],
    ))]
    ,
    ): Container();
  }
}
