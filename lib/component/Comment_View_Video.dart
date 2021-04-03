import 'package:flutter/material.dart';
import 'Circle_Icon.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../firebase/Firebase_User_Data_Agent.dart';
import '../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CommentViewVideo extends StatefulWidget {
  String username, iconURL, description, postCreatorUID, commentID, postID;
  Timestamp commentDate;

  CommentViewVideo(
      {@required username,
      @required String iconURL,
      @required Timestamp commentDate,
      @required String description,
      @required String postCreatorUID,
      @required String commentID,
      @required postID}) {

    this.username = username;
    this.iconURL = iconURL;
    this.commentDate = commentDate;
    this.description = description;
    this.postCreatorUID = postCreatorUID;
    this.commentID = commentID;
    this.postID = postID;

  }

  @override
  _CommentViewVideoState createState() => _CommentViewVideoState();
}

class _CommentViewVideoState extends State<CommentViewVideo> {
  FirebaseUserDataAgent userAgent = new FirebaseUserDataAgent();
  VideoPlayerController _videoController;

  firebase_storage.FirebaseStorage _storageInstance =
      firebase_storage.FirebaseStorage.instance;

  bool deleted = false;

  Future<String> getPostVideoURL() async {
    String url;
    url = await _storageInstance
        .ref('/post/' + widget.postID + '/' + widget.commentID + '.mp4')
        .getDownloadURL();
    print("postID" + widget.postID);

    _videoController = VideoPlayerController.network(url);

    print("Start Initialize" + url);
    //await _videoController.setLooping(true);
    await _videoController.initialize();
    await _videoController.setLooping(true);

    return url;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !deleted
        ? Column(
            children: [
              ListTile(
                dense: true,
                leading: InkWell(
                  child: FutureBuilder(
                    future: userAgent.getUserIconURL(widget.username),
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
                  onTap: () {
                    Navigator.pushNamed(context, "profile/" + widget.username);
                  },
                ),
                title: FutureBuilder(
                  future: userAgent.getDisplayName(widget.username),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                subtitle: Text("Comment at " +
                    DateTime.fromMillisecondsSinceEpoch(
                            widget.commentDate.millisecondsSinceEpoch)
                        .toLocal()
                        .toString()
                        .substring(0, 19)),
              ),
              Divider(
                color: Colors.greenAccent[400],
              ),
              Container(
                  child: FutureBuilder(
                      future: getPostVideoURL(),
                      builder: (builder, snapshot) {
                        if (snapshot.hasData) {
                          _videoController.play();
                          return AspectRatio(
                            aspectRatio: _videoController.value.aspectRatio,
                            child: VideoPlayer(_videoController),
                          );
                        } else {
                          return Container();
                        }
                      })),
              Container(
                padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                child: Text(widget.description),
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
                                  .getUID()) ||
                          (widget.postCreatorUID ==
                              Provider.of<LoginStateNotifier>(context,
                                      listen: false)
                                  .getUID())
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            CollectionReference post =
                                FirebaseFirestore.instance.collection(
                                    "post/" + widget.postID + "/comment");

                            final snackBar = SnackBar(
                              content: Text("Comment Deleted"),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 1, milliseconds: 500),
                            );

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title:
                                        Text("Are you sure to delete comment?"),
                                    content:
                                        Text("This action is unrevertible"),
                                    actions: [
                                      TextButton(
                                        child: Text("Delete"),
                                        onPressed: () async {
                                          await post
                                              .doc(widget.commentID)
                                              .delete()
                                              .then((value) =>
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar));

                                          setState(() {
                                            deleted = true;
                                          });

                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                        )
                      : Container()),
                ],
              ))
            ],
          )
        : Container();
  }
}
