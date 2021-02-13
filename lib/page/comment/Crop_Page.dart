import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as ImageProcess;

import '../comment/Comment_Crop_Part_Page.dart';

class CropPage extends StatefulWidget {
  final Uint8List photoByte;
  CropPage({Key key, this.photoByte}) : super(key: key);

  @override
  _CropPageState createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  final cropKey = GlobalKey<CropState>();

  int StartX, StartY, EndX, EndY;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo Cropping'), actions: []),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.navigate_before),
        onPressed: () {
          final area = cropKey.currentState.area;
          print(area);
          StartX = (cropKey.currentState.area.left * ImageProcess.decodeJpg(widget.photoByte).width).floorToDouble().toInt();
          StartY = (cropKey.currentState.area.top * ImageProcess.decodeJpg(widget.photoByte).height).floorToDouble().toInt();
          EndX = (cropKey.currentState.area.right * ImageProcess.decodeJpg(widget.photoByte).width).floorToDouble().toInt();
          EndY = (cropKey.currentState.area.bottom * ImageProcess.decodeJpg(widget.photoByte).height).floorToDouble().toInt();
          print("Start=($StartX,$StartY) End=($EndX,$EndY)");
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CommentCropPartPage(photoByte: widget.photoByte,StartX: StartX,StartY:StartY,EndX:EndX,EndY:EndY)),
          );
        },
      ),
    );
  }
}
