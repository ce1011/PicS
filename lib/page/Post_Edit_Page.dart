import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';

class PostEditPage extends StatefulWidget {

  String postID, description;

  PostEditPage(this.postID, this.description);

  @override
  _PostEditPageState createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  List<String> groupList;
  String visiblePermissionPath, ableToCommentForPath;
  bool visibleForPublic = true;
  bool ableToCommentForPublic = true;
  bool hideForEveryone = false;

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  TextEditingController descriptionController = new TextEditingController();

  Future<List<QueryDocumentSnapshot>> getPermissionGroup(
      BuildContext context) async {
    List<QueryDocumentSnapshot> permissionGroupList;

    descriptionController.text = widget.description;

    await firestoreInstance
        .collection("groupDB/" +
        Provider.of<LoginStateNotifier>(context, listen: false).getUID() +
        "/groups")
        .where('ableForPostPermissionManagement', isEqualTo: true)
        .get()
        .then((value) => permissionGroupList = value.docs);

    return permissionGroupList;
  }

  void updatePostContent(BuildContext context){

    CollectionReference post = firestoreInstance.collection("post");
    CollectionReference groupDB = firestoreInstance.collection("groupDB");

    Map<String, dynamic> update = {
      'permission.ableToCommentForPublic': ableToCommentForPublic,
      'permission.visibleForPublic':visibleForPublic,
    };

    if(ableToCommentForPublic == false){
      if(hideForEveryone == true){
        post.doc(widget.postID).update({
          'permission.ableToCommentFor': null,
        });
      }else{
        post.doc(widget.postID).update({
          'permission.ableToCommentFor': groupDB.doc(ableToCommentForPath.substring(8)),
        });
      }

    }else{
      post.doc(widget.postID).update({
        'permission.ableToCommentFor': null,
      });
    }

    if(visibleForPublic == false){
      if(hideForEveryone == true){
        post.doc(widget.postID).update({
          'permission.visibleFor': null,
        });
      }else{
        post.doc(widget.postID).update({
          'permission.visibleFor': groupDB.doc(visiblePermissionPath.substring(8)),
        });
      }

    }else{
      post.doc(widget.postID).update({
        'permission.visibleFor': null,
      });
    }


    post.doc(widget.postID).update({
      'description': descriptionController.text,
      'permission.ableToCommentForPublic': ableToCommentForPublic,
      'permission.visibleForPublic':visibleForPublic,
    }).then((value) => Navigator.pop(context));
    print(widget.postID);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post Editing"), actions: [IconButton(icon: Icon(Icons.send), onPressed: (){
        updatePostContent(context);
      },)],),
      body: Column(
        children: [
          Center(
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Type your comment...',
                ),
                controller: descriptionController,
                minLines: 6,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              )),
          FutureBuilder(
              future: getPermissionGroup(context),
              builder: (context,
                  AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                if (snapshot.hasData) {
                  return Column(children: [
                    Text("Visible For"),
                    DropdownButton(
                        value: visiblePermissionPath,
                        onChanged: (String value) {
                          setState(() {
                            visiblePermissionPath = value;
                          });
                        },
                        items: snapshot.data.map<DropdownMenuItem<String>>(
                                (QueryDocumentSnapshot data) {
                              return DropdownMenuItem(
                                value: data.reference.path,
                                child: Text(data.id),
                              );
                            }).toList()),
                    Text("Able Comment For"),
                    DropdownButton(
                        value: ableToCommentForPath,
                        onChanged: (String value) {
                          setState(() {
                            ableToCommentForPath = value;
                          });
                        },
                        items: snapshot.data.map<DropdownMenuItem<String>>(
                                (QueryDocumentSnapshot data) {
                              return DropdownMenuItem(
                                value: data.reference.path,
                                child: Text(data.id),
                              );
                            }).toList())
                  ]);
                } else {
                  return Container();
                }
              }),
          Text("visibleForPublic"),
          Checkbox(
            value: visibleForPublic,
            onChanged: (value) {
              setState(() {
                visibleForPublic = value;
              });
            },
          ),
          Text("ableToCommentForPublic"),
          Checkbox(
            value: ableToCommentForPublic,
            onChanged: (value) {
              setState(() {
                ableToCommentForPublic = value;
              });
            },
          ),
          Text("Hide For Everyone"),
          Checkbox(
            value: hideForEveryone,
            onChanged: (value) {
              setState(() {
                hideForEveryone = value;
                ableToCommentForPublic = false;
                visibleForPublic = false;
              });
            },
          ),
        ],
      ),
    );
  }

}