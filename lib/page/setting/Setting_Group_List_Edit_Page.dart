import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../firebase/Firebase_User_Data_Agent.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SettingGroupListEditPage extends StatefulWidget {
  DocumentReference docsRef;
  String groupName;

  SettingGroupListEditPage({this.groupName, this.docsRef});

  @override
  _SettingGroupListEditPageState createState() =>
      _SettingGroupListEditPageState();
}

class _SettingGroupListEditPageState extends State<SettingGroupListEditPage> {
  FirebaseUserDataAgent firebaseUserDataAgent = FirebaseUserDataAgent();
  TextEditingController addUserTextController = TextEditingController();

  Future<void> updateGroup(String groupName) {}

  Stream<Iterable<String>> getUIDList() {
    DocumentReference firestoreInstance =
        FirebaseFirestore.instance.doc(widget.docsRef.path);

    var temp;
    var UIDList;

    temp = firestoreInstance.snapshots();

    UIDList = temp.data()['UID'].keys;

    return temp.data()['UID'].keys;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.groupName),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Add user"),
                          content: TextField(
                            controller: addUserTextController,
                          ),
                          actions: [
                            TextButton(
                              child: Text("Add"),
                              onPressed: () async {
                                var uid = await firebaseUserDataAgent
                                    .getUIDByUsername(
                                        addUserTextController.text);

                                await FirebaseFirestore.instance
                                    .doc(widget.docsRef.path)
                                    .update({'UID.' + uid: true});

                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                })
          ],
        ),
        body: Container(
            padding: EdgeInsets.only(
              left: (MediaQuery.of(context).size.width >= 1080.0)
                  ? (MediaQuery.of(context).size.width) * 0.25
                  : 0,
              right: (MediaQuery.of(context).size.width >= 1080.0)
                  ? (MediaQuery.of(context).size.width) * 0.25
                  : 0,
            ),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .doc(widget.docsRef.path)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var i in snapshot.data.data()['UID'].keys)
                          ListTile(
                              title: FutureBuilder(
                            future: Future.wait([
                              firebaseUserDataAgent.getDisplayName(i),
                              firebaseUserDataAgent.getUserName(i)
                            ]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  child: ListTile(
                                    title: Text(snapshot.data[1]),
                                    subtitle: Text(snapshot.data[0]),
                                  ),
                                  secondaryActions: [
                                    IconSlideAction(
                                      caption: "Remove",
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .doc(widget.docsRef.path)
                                            .update({
                                          'UID.' + i: FieldValue.delete()
                                        });
                                      },
                                    )
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            },
                          ))
                      ],
                    );
                  } else {
                    return Container();
                  }
                })));
  }
}
