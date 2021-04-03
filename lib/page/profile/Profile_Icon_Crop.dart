import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as ImageProcess;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';

class ProfileIconCropPage extends StatefulWidget {
  final Uint8List photoByte;
  String postID;

  ProfileIconCropPage({Key key, this.photoByte}) : super(key: key);

  @override
  _ProfileIconCropPageState createState() => _ProfileIconCropPageState();
}

class _ProfileIconCropPageState extends State<ProfileIconCropPage> {
  firebase_storage.FirebaseStorage storageInstance =
      firebase_storage.FirebaseStorage.instance;

  final cropKey = GlobalKey<CropState>();

  int StartX, StartY, EndX, EndY;

  Uint8List photoByte_process;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Icon Cropping'), actions: [
        IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () async {
              final area = cropKey.currentState.area;
              print(area);
              StartX = (cropKey.currentState.area.left *
                  ImageProcess.decodeJpg(widget.photoByte).width)
                  .floorToDouble()
                  .toInt();
              StartY = (cropKey.currentState.area.top *
                  ImageProcess.decodeJpg(widget.photoByte).height)
                  .floorToDouble()
                  .toInt();
              EndX = (cropKey.currentState.area.right *
                  ImageProcess.decodeJpg(widget.photoByte).width)
                  .floorToDouble()
                  .toInt();
              EndY = (cropKey.currentState.area.bottom *
                  ImageProcess.decodeJpg(widget.photoByte).height)
                  .floorToDouble()
                  .toInt();
              print("Start=($StartX,$StartY) End=($EndX,$EndY)");

              photoByte_process = await ImageProcess.encodeJpg(ImageProcess.copyCrop(
                  ImageProcess.decodeJpg(widget.photoByte),
                  StartX,
                  StartY,
                  EndX - StartX,
                  EndY - StartY));

                await storageInstance.ref('usericon/' + Provider.of<LoginStateNotifier>(context, listen: false).getUID() + '.jpg').putData(photoByte_process);
                Navigator.pop(context);

              /*
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommentCropPartPage(
                      photoByte: widget.photoByte,
                      StartX: StartX,
                      StartY: StartY,
                      EndX: EndX,
                      EndY: EndY,
                      postID: widget.postID,
                    )),
              );*/
            })
      ]),
      body: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Crop(
              key: cropKey,
              image: MemoryImage(widget.photoByte),
              maximumScale: 1.0,
            ),
          )),
    );
  }
}
