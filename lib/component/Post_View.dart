import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'Circle_Icon.dart';

class PostView extends StatefulWidget {
  String username, iconURL, postDate, imageURL, description;
  PostView({@required username,@required String iconURL,@required String postDate,@required String imageURL,@required String description}){
    this.username = username;
    this.iconURL = iconURL;
    this.postDate = postDate;
    this.imageURL = imageURL;
    this.description = description;
  }

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
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
                widget.imageURL)),
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
}
