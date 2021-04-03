import 'package:flutter/material.dart';
import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import '../../firebase/Firebase_User_Data_Agent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ViewFriendPage extends StatefulWidget {
  @override
  _ViewFriendPageState createState() => _ViewFriendPageState();
}

class _ViewFriendPageState extends State<ViewFriendPage> {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  FirebaseUserDataAgent firebaseUserDataAgent = FirebaseUserDataAgent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
      ),
      body: Container(
          child: StreamBuilder(
        stream: firestoreInstance
            .collection("groupDB/" +
                Provider.of<LoginStateNotifier>(context, listen: false)
                    .getUID() +
                "/groups")
            .doc("friends")
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
                              caption: "Delete",
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                firestoreInstance
                                    .collection("groupDB/" +
                                        Provider.of<LoginStateNotifier>(context,
                                                listen: false)
                                            .getUID() +
                                        "/groups")
                                    .doc("friends")
                                    .update({'UID.' + i: FieldValue.delete()});

                                firestoreInstance
                                    .collection("groupDB/" +
i +
                                    "/groups")
                                    .doc("friends")
                                    .update({'UID.' +                                     Provider.of<LoginStateNotifier>(context,
                                    listen: false)
                                    .getUID(): FieldValue.delete()});
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
        },
      )),
    );
  }
}
