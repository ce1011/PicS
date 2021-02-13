import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as ImageProcess;
import 'package:http/http.dart' as http;

import '../../component/Comment_Crop_Photo.dart';
import '../comment/Crop_Page.dart';

class ViewCommentPage extends StatefulWidget {
  @override
  _ViewCommentPageState createState() => _ViewCommentPageState();
}

class _ViewCommentPageState extends State<ViewCommentPage> {
  Uint8List photoByte;
  ImageProcess.Image photo;

  @override
  void initState() {
    super.initState();

    getPhoto();
  }

  Future<void> getPhoto() async {
    var url =
        'https://free4kwallpapers.com/uploads/wallpaper/ultraviolet-wallpaper-1280x720-wallpaper.jpg';

    var response = await http.get(url);

    this.photoByte = response.bodyBytes;

    this.photo = ImageProcess.decodeJpg(photoByte);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comment")),
      body: Container(
          child: FutureBuilder<void>(
        future: getPhoto(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return CommentCropPhoto(photoByte, StartX: 0, StartY: 0, EndX:500,EndY:500);
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      )),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.navigate_next), onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CropPage(photoByte: photoByte,)),
        );
      },),
    );
  }
}

//ImageProcess.encodeJpg(ImageProcess.copyCrop(ImageProcess.decodeJpg(photoByte),0 , 0, 200, 200))
