import 'package:flutter/material.dart';
import 'Circle_Icon.dart';
import 'Comment_Crop_Photo.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentView extends StatefulWidget {
  String username, iconURL, description;
  Timestamp commentDate;
  int StartX, StartY, EndX, EndY;
  Uint8List photoByte;

  CommentView({@required username,@required String iconURL,@required Timestamp commentDate,@required Uint8List photoByte,@required int StartX,@required int StartY,@required int EndX,@required int EndY, @required String description}){
    this.username = username;
    this.iconURL = iconURL;
    this.commentDate = commentDate;
    this.photoByte = photoByte;
    this.description = description;
    this.StartX = StartX;
    this.StartY = StartY;
    this.EndX = EndX;
    this.EndY = EndY;
  }

  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          leading: CircleIcon(
              url: widget.iconURL),
          title: Text(widget.username),
          subtitle: Text("Comment at "+DateTime.fromMillisecondsSinceEpoch(widget.commentDate.millisecondsSinceEpoch).toLocal().toString().substring(0,19)),
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
                IconButton(icon: Icon(Icons.favorite), onPressed: (){

                },),
                IconButton(icon: Icon(Icons.forward),onPressed: (){

                }),
              ],
            ))
      ],
    );
  }
}
