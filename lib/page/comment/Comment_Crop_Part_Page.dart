import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as ImageProcess;
import '../../component/Comment_Crop_Photo.dart';

class CommentCropPartPage extends StatelessWidget {
  final Uint8List photoByte;
  int StartX, StartY, EndX, EndY;

  final TextEditingController commentInputController =
      new TextEditingController();

  CommentCropPartPage(
      {this.photoByte, this.StartX, this.StartY, this.EndX, this.EndY});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Crop Comment"), actions: [IconButton(icon: Icon(Icons.send), onPressed: (){
          int count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 2;
          });
        })],),
        body: Container(
            padding: EdgeInsets.only(
              left: (MediaQuery.of(context).size.width >= 1080.0)
                  ? (MediaQuery.of(context).size.width) * 0.25
                  : (MediaQuery.of(context).size.width) * 0.04,
              right: (MediaQuery.of(context).size.width >= 1080.0)
                  ? (MediaQuery.of(context).size.width) * 0.25
                  : (MediaQuery.of(context).size.width) * 0.04,
            ),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CommentCropPhoto(
                    photoByte,
                    StartX: StartX,
                    StartY: StartY,
                    EndX: EndX,
                    EndY: EndY,
                  ),
                ),
                Container(
                    child: Card(
                        child: Container(
                  padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                  child: Column(children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Type your comment...',
                      ),
                      controller: commentInputController,
                      minLines: 6,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    )
                  ]),
                )))
              ],
            )),
    );
  }
}
