import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../page/Post_Edit_Page.dart';
import 'Circle_Icon.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../firebase/Firebase_User_Data_Agent.dart';
import '../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class PostView extends StatefulWidget {
  String username, postID, description;
  Timestamp postDate;
  bool videoMode;

  PostView(
      {@required username,
      @required Timestamp postDate,
      @required String postID,
      @required String description,
      @required bool videoMode}) {
    this.username = username;
    this.postDate = postDate;
    this.postID = postID;
    this.description = description;
    this.videoMode = videoMode;
  }

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  FirebaseUserDataAgent userAgent = new FirebaseUserDataAgent();
  bool deleted = false;
  VideoPlayerController _videoController;

  firebase_storage.FirebaseStorage _storageInstance =
      firebase_storage.FirebaseStorage.instance;

  Future<bool> loadVideo() async {
    print("Start Initialize");
    //await _videoController.setLooping(true);
    await _videoController.initialize();
    //await     _videoController.setLooping(true);

    return true;
  }

  Future<String> getPostImageURL(String postID) async {
    String url;
    url =
        await _storageInstance.ref('/post/' + postID + '.jpg').getDownloadURL();
    return url;
  }

  Future<String> getPostVideoURL(String postID) async {
    String url;
    url =
    await _storageInstance.ref('/post/' + postID + '.mp4').getDownloadURL();

    _videoController = VideoPlayerController.network(url);
    return url;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoController.dispose();
    super.dispose();
  }



  Future<void> deleteConfirm() async {

  }

  @override
  Widget build(BuildContext context) {
    print(widget.postID + " " + widget.videoMode.toString());
    return !deleted
        ? FutureBuilder(
            future: (widget.videoMode == false) ? getPostImageURL(widget.postID) : getPostVideoURL(widget.postID) ,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text("Error");
                } else {
                  return Column(
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
                                          image: AssetImage('photo/emptyusericon.jpg'))),
                                );
                              }
                            },
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                                context, "profile/" + widget.username);
                          },
                        ),
                        title: FutureBuilder(
                          future: userAgent.getDisplayName(widget.username),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
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
                        subtitle: Text("Post at " +
                            DateTime.fromMillisecondsSinceEpoch(
                                    widget.postDate.millisecondsSinceEpoch)
                                .toLocal()
                                .toString()
                                .substring(0, 19)),
                      ),
                      Divider(),
                      Container(child:  (widget.videoMode == false) ? Image.network(snapshot.data) : FutureBuilder(
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
                        padding:
                            EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                        child: Text(widget.description),
                      ),
                      Divider(),
                      Container(
                          child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, "/post/${widget.postID}/comment");
                            },
                          ),
                          (widget.username ==
                                  Provider.of<LoginStateNotifier>(context,
                                          listen: false)
                                      .getUID())
                              ? IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    CollectionReference post = FirebaseFirestore
                                        .instance
                                        .collection('post');

                                    final snackBar = SnackBar(
                                      content: Text("Post Deleted"),
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(
                                          seconds: 1, milliseconds: 500),
                                    );

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Are you sure to delete post?"),
                                            content: Text(
                                                "This action is unrevertible"),
                                            actions: [
                                              TextButton(
                                                child: Text("Delete", style: TextStyle(color: Colors.greenAccent[400],),),
                                                onPressed: () async {
                                                  await post
                                                      .doc(widget.postID)
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
                                  },
                                )
                              : Container(),
                          (widget.username ==
                              Provider.of<LoginStateNotifier>(context,
                                  listen: false)
                                  .getUID()) ? IconButton(icon: Icon(Icons.edit), onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PostEditPage(widget.postID, widget.description)));
                          }) : Container()
                        ],
                      ))
                    ],
                  );
                }
              } else {
                return Text("ok");
              }
            })
        : Container();
  }
}
