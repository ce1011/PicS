import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'Circle_Icon.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../firebase/Firebase_User_Data_Agent.dart';

class PostView extends StatefulWidget {
  String username, iconURL, postID, description;
  Timestamp postDate;

  PostView(
      {@required username,
      @required String iconURL,
      @required Timestamp postDate,
      @required String postID,
      @required String description}) {
    this.username = username;
    this.iconURL = iconURL;
    this.postDate = postDate;
    this.postID = postID;
    this.description = description;
  }

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  FirebaseUserDataAgent userAgent = new FirebaseUserDataAgent();

  firebase_storage.FirebaseStorage _storageInstance =
      firebase_storage.FirebaseStorage.instance;

  Future<String> getPostImageURL(String postID) async {
    String url;
    url =
        await _storageInstance.ref('/post/' + postID + '.jpg').getDownloadURL();
    return url;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPostImageURL(widget.postID),
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
                    subtitle: Text("Post at " +
                        DateTime.fromMillisecondsSinceEpoch(
                                widget.postDate.millisecondsSinceEpoch)
                            .toLocal()
                            .toString()
                            .substring(0, 19)),
                  ),
                  Divider(),
                  Container(child: Image.network(snapshot.data)),
                  Container(
                    padding:
                        EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                    child: Text(widget.description),
                  ),
                  Divider(),
                  Container(
                      child: Row(
                    children: [
                      IconButton(icon: Icon(Icons.favorite)),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, "/post/${widget.postID}/comment");
                        },
                      ),
                      IconButton(icon: Icon(Icons.forward)),
                    ],
                  ))
                ],
              );
            }
          } else {
            return Text("ok");
          }
        });
  }
}
