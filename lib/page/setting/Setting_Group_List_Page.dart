import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../firebase/Firebase_User_Data_Agent.dart';
import 'Setting_Group_List_Edit_Page.dart';
import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';

class SettingGroupListPage extends StatelessWidget {
  FirebaseUserDataAgent firebaseUserDataAgent = FirebaseUserDataAgent();
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  TextEditingController addPermissionGroupTextController = TextEditingController();

  QuerySnapshot groupList;

  Future<List<QueryDocumentSnapshot>> getPermissionGroup(
      BuildContext context) async {
    List<QueryDocumentSnapshot> permissionGroupList;

    await firestoreInstance.collection("groupDB/" +
        Provider.of<LoginStateNotifier>(context, listen: false).getUID() +
        "/groups").where("visibleInPermissionGroupEditing", isEqualTo: true).get().then((value) => permissionGroupList = value.docs);


    return permissionGroupList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Permission Group Editing"),          actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Add permission group"),
                        content: TextField(
                          controller: addPermissionGroupTextController,
                        ),
                        actions: [
                          TextButton(
                            child: Text("Add"),
                            onPressed: () async {
                              
                              await firestoreInstance.collection("groupDB/" +
                                  Provider.of<LoginStateNotifier>(context, listen: false).getUID() +
                                  "/groups").doc(addPermissionGroupTextController.text).set({'visibleInPermissionGroupEditing': true , 'ableForPostPermissionManagement': true});


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
            child: StreamBuilder(
                stream: firestoreInstance.collection("groupDB/" +
                    Provider.of<LoginStateNotifier>(context, listen: false).getUID() +
                    "/groups").where("visibleInPermissionGroupEditing", isEqualTo: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for(var i in snapshot.data.docs) ListTile(title: Text(i.id), onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingGroupListEditPage(groupName: i.id, docsRef: i.reference,)),
                          );
                        },)
                      ],
                    );
                  } else {
                    return Container();
                  }
                })));
  }
}
