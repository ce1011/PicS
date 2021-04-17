import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class PickImagePage extends StatefulWidget {
  @override
  _PickImagePageState createState() => _PickImagePageState();
}

class _PickImagePageState extends State<PickImagePage> {
  TextEditingController description = new TextEditingController();

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storageInstance =
      firebase_storage.FirebaseStorage.instance;

  Uint8List _image;
  VideoPlayerController _videoController;
  final picker = ImagePicker();
  List<String> groupList;
  String visiblePermissionPath, ableToCommentForPath;
  bool visibleForPublic = true;
  bool ableToCommentForPublic = true;
  bool private =false;
  bool videoMode = false;
  File videoPath;

  Future getImageFromGallery() async {
    FilePickerResult result;
    if(kIsWeb){
      result = await FilePicker.platform
          .pickFiles(type: FileType.custom, withData: true, allowedExtensions: ['jpg','png'],);
    }else{
      result = await FilePicker.platform
          .pickFiles(type: FileType.custom, withData: true, allowedExtensions: ['jpg','png','mp4']);

    }


    if (result != null) {
      PlatformFile file = result.files.first;

      if (file.extension != "mp4") {
        _image = file.bytes;
      } else {
        videoPath = File(file.path);
        _videoController = VideoPlayerController.file(videoPath);
        videoMode = true;
      }

      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  Future<bool> loadVideo() async {
    print("Start Initialize");
    //await _videoController.setLooping(true);
    await _videoController.initialize();

    return true;
  }

  Future postClipToDatabase(BuildContext context) async {
    CollectionReference post = firestoreInstance.collection("post");
    CollectionReference groupDB = firestoreInstance.collection("groupDB");

    String postID;

    var document = {
      'UID': Provider.of<LoginStateNotifier>(context, listen: false).getUID(),
      'description': description.text,
      'postTime': Timestamp.now(),
      'video': videoMode
    };

    var permission = {};
    permission['ableToCommentForPublic'] =ableToCommentForPublic;
    permission['visibleForPublic'] =visibleForPublic;
    if(ableToCommentForPublic == false){
      permission['ableToCommentFor'] = groupDB.doc(ableToCommentForPath.substring(8));
    }else{
      permission['ableToCommentFor'] = null;
    }
    if(visibleForPublic == false){
      permission['visibleFor'] = groupDB.doc(visiblePermissionPath.substring(8));
    }else{
      permission['visibleFor'] = null;
    }
    if(private == true){
      permission['visibleFor'] = null;
      permission['ableToCommentFor'] = null;
    }
    
    document['permission'] = permission;

    await post.add(document).then((value) => postID = value.id);

    if (videoMode == false) {
      try {
        await storageInstance.ref('post/' + postID + '.jpg').putData(_image);
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        print("Error");
      }
    } else {
      try {
        await storageInstance.ref('post/' + postID + '.mp4').putFile(videoPath);
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        print("Error");
      }
    }
  }

  Future<List<QueryDocumentSnapshot>> getPermissionGroup(
      BuildContext context) async {

    List<QueryDocumentSnapshot> permissionGroupList;

    await firestoreInstance.collection("groupDB/" +
        Provider.of<LoginStateNotifier>(context, listen: false).getUID() +
        "/groups").where('ableForPostPermissionManagement' , isEqualTo: true).get().then((value) => permissionGroupList = value.docs);

    return permissionGroupList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pick Image"),
          actions: [
            IconButton(
                icon: Icon(Icons.note_add_outlined),
                onPressed: getImageFromGallery),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                  child: (_image == null && _videoController == null)
                      ? Text("No video/image has selected")
                      : Container()),
              Center(
                  child: (_image == null)
                      ? Container()
                      : Image.memory(_image)),
              Center(
                  child: (_videoController == null)
                      ? Container()
                      : FutureBuilder(
                          future: loadVideo(),
                          builder: (builder, snapshot) {
                            if (snapshot.data == true) {
                              _videoController.play();
                              print(_videoController.dataSourceType);
                              return AspectRatio(
                                aspectRatio: _videoController.value.aspectRatio,
                                child: VideoPlayer(_videoController),
                              );
                            } else {
                              return Text("Readying");
                            }
                          })),
              Center(
                  child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Type your comment...',
                ),
                controller: description,
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
                                visibleForPublic = false;
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
                                ableToCommentForPublic = false;
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
                    if(value == true){
                      visiblePermissionPath = null;
                    }
                    visibleForPublic = value;
                  });
                },
              ),
              Text("ableToCommentForPublic"),
              Checkbox(
                value: ableToCommentForPublic,
                onChanged: (value) {
                  setState(() {
                    if(value == true){
                      ableToCommentForPath = null;
                    }
                    ableToCommentForPublic = value;


                  });
                },
              ),
              Text("Private"),
              Checkbox(
                value: private,
                onChanged: (value) {
                  setState(() {
                    if(value == false){
                      visibleForPublic = true;
                      ableToCommentForPublic= true;
                      ableToCommentForPath = null;
                      private = value;
                    }else{
                      visibleForPublic = false;
                      ableToCommentForPublic= false;
                      private = value;
                    }

                  });
                },
              ),
              Center(
                  child: RaisedButton(
                child: Text("Send"),
                onPressed: () {
                  postClipToDatabase(context);
                },
              ))
            ],
          ),
        ));
  }
}
