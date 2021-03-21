import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileEditPage extends StatelessWidget {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  final TextEditingController userNameInputController =
      new TextEditingController();
  final TextEditingController displayNameInputController =
      new TextEditingController();
  final TextEditingController descriptionInputController =
      new TextEditingController();

  Future<bool> commitProfileChange(BuildContext context) async {
    CollectionReference profile = firestoreInstance.collection("user");

    String UID;

    bool success;

    await profile
        .where('UID',
            isEqualTo: Provider.of<LoginStateNotifier>(context, listen: false)
                .getUID())
        .get()
        .then((data) => UID = data.docs[0].id);

    await profile.doc("/" + UID).update({
      "displayName": displayNameInputController.text,
      "username": userNameInputController.text,
      "description": descriptionInputController.text
    }).then((value) => success = true);

    Provider.of<LoginStateNotifier>(context, listen: false)
        .setDisplayName(displayNameInputController.text);
    Provider.of<LoginStateNotifier>(context, listen: false)
        .setUsername(userNameInputController.text);
    Provider.of<LoginStateNotifier>(context, listen: false)
        .setDescription(descriptionInputController.text);

    return success;
  }

  @override
  Widget build(BuildContext context) {
    userNameInputController.text =
        Provider.of<LoginStateNotifier>(context, listen: false).getUsername();
    displayNameInputController.text =
        Provider.of<LoginStateNotifier>(context, listen: false)
            .getDisplayName();
    descriptionInputController.text =
        Provider.of<LoginStateNotifier>(context, listen: false)
            .getDescription();

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                if (await commitProfileChange(context) == true) {
                  Navigator.pop(context);
                } else {
                  print("error");
                }
              })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: (MediaQuery.of(context).size.width >= 1080.0)
                ? (MediaQuery.of(context).size.width) * 0.3
                : (MediaQuery.of(context).size.width) * 0.04,
            right: (MediaQuery.of(context).size.width >= 1080.0)
                ? (MediaQuery.of(context).size.width) * 0.3
                : (MediaQuery.of(context).size.width) * 0.04,
            top: 8.0),
        child: Column(
          children: [
            TextField(
              controller: userNameInputController,
              decoration: InputDecoration(
                labelText: "Username",
                enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Color(0xFF2308423))),
                focusedBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.greenAccent[400])),
              ),
            ),
            TextField(
              controller: displayNameInputController,
              decoration: InputDecoration(
                labelText: "Display Name",
                enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Color(0xFF2308423))),
                focusedBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.greenAccent[400])),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
              controller: descriptionInputController,
              minLines: 6,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
