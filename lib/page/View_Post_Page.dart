import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ViewPostPage extends StatefulWidget {
  String postID;

  ViewPostPage(this.postID);

  @override
  _ViewPostPageState createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  FirebaseFunctions functions = FirebaseFunctions.instance;

  bool canBeView = false, canComment = false;

  Future<void> getPostData() async {
    await functions
        .httpsCallable('viewPostAvalibility')
        .call(<String, dynamic>{'postID': widget.postID}).then((data) =>
            {canBeView = data.data['view'], canComment = data.data['comment']});

    if(canBeView == true){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
