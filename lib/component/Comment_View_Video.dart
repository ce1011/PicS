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
  int StartX, StartY, EndX, EndY, startSecond, endSecond;
  Uint8List photoByte;

  CommentViewVideo(
      {@required username, @required String iconURL, @required Timestamp commentDate, @required Uint8List photoByte, @required int StartX, @required int StartY, @required int EndX, @required int EndY, @required String description, @required String postCreatorUID, @required String commentID, @required postID, @required int endSecond, @required int startSecond}) {
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
    this.startSecond = startSecond;
    this.endSecond = endSecond;
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

  Future<String> getPostVideoURL(String postID) async {
    String url;
    url =
    await _storageInstance.ref('/post/' + postID + '.mp4').getDownloadURL();

    _videoController = VideoPlayerController.network(url);
    return url;
  }

  Future<bool> loadVideo() async {
    print("Start Initialize");
    //await _videoController.setLooping(true);
    await _videoController.initialize();
    await _videoController.setLooping(true);

    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoController.dispose();
    super.dispose();
  }

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
            FutureBuilder(
                future: loadVideo(),
                builder: (builder, snapshot) {
                  if (snapshot.data == true) {
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
