import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import '../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../component/Post_View.dart';

class ViewPostPage extends StatefulWidget {
  String postID;

  ViewPostPage(this.postID);

  @override
  _ViewPostPageState createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  FirebaseFunctions functions = FirebaseFunctions.instance;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future<Map<String, bool>> getPostCanData() async {
    Map<String, bool> can = {'view': false, 'comment': false};

    print("getCanData");
    try {
      await functions
          .httpsCallable('viewPostAvalibility')
          .call(<String, dynamic>{'postID': widget.postID}).then((value) => {
                can['view'] = value.data['view'],
                can['comment'] = value.data['comment']
              });

      return can;
    } on FirebaseFunctionsException catch (e) {
      print(
          'Cloud functions exception with code: ${e.code}, and Details: ${e.details}, with message: ${e.message} ');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<DocumentSnapshot> getPostData() async {
    DocumentSnapshot postData;
    await firestoreInstance
        .collection('post')
        .doc(widget.postID)
        .get()
        .then((value) => postData = value);
    return postData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("postID: " + widget.postID);

    Future(() {
      final snackBar = SnackBar(
        content: Text(
            "Please login with current account or login as annonymus first and enter post page again."),
        duration: Duration(seconds: 1, milliseconds: 500),
      );
      if (Provider.of<LoginStateNotifier>(context, listen: false).loginState ==
          false) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.popAndPushNamed(context, "/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Post"),
        ),
        body: FutureBuilder(
          future: getPostCanData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    (snapshot.data['view'])
                        ? FutureBuilder(
                            future: getPostData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                    padding: EdgeInsets.only(
                                      left: (MediaQuery.of(context).size.width >= 1080.0)
                                          ? (MediaQuery.of(context).size.width) * 0.25
                                          : 0,
                                      right: (MediaQuery.of(context).size.width >= 1080.0)
                                          ? (MediaQuery.of(context).size.width) * 0.25
                                          : 0,
                                    ),
                                    child: PostView(
                                      username: snapshot.data.data()['UID'],
                                      postDate: snapshot.data.data()['postTime'],
                                      postID: snapshot.data.id,
                                      description:
                                          snapshot.data.data()['description'],
                                      videoMode: snapshot.data.data()['video'],
                                    ),
                                  
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            })
                        : Container()
                  ],
                ),
              );
            } else {
              return Center(
                child: Text("Loading Can"),
              );
            }
          },
        ));
  }
}
