import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../firebase/Firebase_User_Data_Agent.dart';
import '../../component/Circle_Icon.dart';
import 'package:file_picker/file_picker.dart';
import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import '../profile/Profile_Icon_Crop.dart';

class ProfileEditPage extends StatelessWidget {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  final TextEditingController userNameInputController =
      new TextEditingController();
  final TextEditingController displayNameInputController =
      new TextEditingController();
  final TextEditingController descriptionInputController =
      new TextEditingController();

  FirebaseUserDataAgent firebaseUserDataAgent = FirebaseUserDataAgent();

  Uint8List _image;
  final picker = ImagePicker();

  Future getImageFromGallery() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.media, withData: true);

    if (result != null) {
      PlatformFile file = result.files.first;

      _image = file.bytes;
    } else {
      print('No image selected.');
    }
  }

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
            FutureBuilder(
              future: firebaseUserDataAgent.getUserIconURL(
                  Provider.of<LoginStateNotifier>(context, listen: false).UID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return InkWell(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(snapshot.data))),
                    ),
                    onTap: () async {
                      await getImageFromGallery();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileIconCropPage(
                                    photoByte: _image,
                                  )));
                    },
                  );
                } else {
                  return InkWell(
                    child: Container(
                      height: 400,
                      width: 400,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/photo/emptyusericon.jpg'))),

                    ),                      onTap: () async {
                    await getImageFromGallery();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileIconCropPage(
                              photoByte: _image,
                            )));
                  },
                  );
                }
              },
            ),
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
