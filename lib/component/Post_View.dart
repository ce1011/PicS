import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'Circle_Icon.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PostView extends StatefulWidget {
  String username, iconURL, postDate, postID, description;
  PostView({@required username,@required String iconURL,@required String postDate,@required String postID,@required String description}){
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
  firebase_storage.FirebaseStorage _storageInstance = firebase_storage.FirebaseStorage.instance;

  Future<String> getPostImageURL(String postID) async {
    String url;
    url = await _storageInstance.ref('/post/'+postID+'.jpg').getDownloadURL();
    return url;
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getPostImageURL(widget.postID),builder: (BuildContext context, AsyncSnapshot<String> snapshot){
      if(snapshot.connectionState == ConnectionState.done){
        if(snapshot.hasError){
  return Text("Error");
        }else{
          return Column(
            children: [
              ListTile(
                dense: true,
                leading: CircleIcon(url: widget.iconURL),
                title: Text(widget.username),
                subtitle: Text(widget.postDate),
              ),
              Divider(),
              Container(
                  child: Image.network(
                      snapshot.data)),
              Container(
                padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                child: Text(
                    widget.description),
              ),
              Divider(),
              Container(
                  child: Row(
                    children: [
                      IconButton(icon: Icon(Icons.favorite)),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          Navigator.pushNamed(context, "/post/1/comment");
                        },
                      ),
                      IconButton(icon: Icon(Icons.forward)),
                    ],
                  ))
            ],
          );

        }
      }else{
        return Text("ok")
;      }
    });
  }
}
