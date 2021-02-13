import 'dart:typed_data';

import 'package:image/image.dart' as ImageProcess;
import 'package:flutter/material.dart';

class CommentCropPhoto extends StatelessWidget {
  int StartX, StartY, EndX, EndY;
  Uint8List photoByte;

  CommentCropPhoto(Uint8List photoByte,
      {int StartX, int StartY, int EndX, int EndY}) {
    this.StartX = StartX;
    this.StartY = StartY;
    this.EndX = EndX;
    this.EndY = EndY;
    this.photoByte = photoByte;
  }

  @override
  Widget build(BuildContext context) {
    return Image.memory(ImageProcess.encodeJpg(ImageProcess.copyCrop(
        ImageProcess.decodeJpg(photoByte),
        StartX,
        StartY,
        EndX - StartX,
        EndY - StartY)));
  }
}
