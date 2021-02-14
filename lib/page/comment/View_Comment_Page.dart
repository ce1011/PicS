import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as ImageProcess;
import 'package:http/http.dart' as http;

import '../../component/Comment_Crop_Photo.dart';
import '../comment/Crop_Page.dart';
import '../../component/Circle_Icon.dart';

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
    //https://cors-anywhere.herokuapp.com/
    var url =
        'https://free4kwallpapers.com/uploads/wallpaper/ultraviolet-wallpaper-1280x720-wallpaper.jpg';

    var response = await http.get(url);

    this.photoByte = response.bodyBytes;

    this.photo = ImageProcess.decodeJpg(photoByte);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comment"), actions: [IconButton(icon: Icon(Icons.add_comment), onPressed: (){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CropPage(
              photoByte: photoByte,
            )),
      );})
    ],),
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(
                left: (MediaQuery.of(context).size.width >= 1080.0)
                    ? (MediaQuery.of(context).size.width) * 0.25
                    : (MediaQuery.of(context).size.width) * 0.04,
                right: (MediaQuery.of(context).size.width >= 1080.0)
                    ? (MediaQuery.of(context).size.width) * 0.25
                    : (MediaQuery.of(context).size.width) * 0.04,
              ),
              child: FutureBuilder<void>(
        future: getPhoto(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Column(children: [
                Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.0))),
                        child: Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: CircleIcon(
                                  url: "https://i.imgur.com/BoN9kdC.png"),
                              title: Text("Handsome"),
                              subtitle: Text("Comment at 31 Feb 2021 23:59"),
                            ),
                            Divider(
                              color: Colors.greenAccent[400],
                            ),
                            Container(
                                child: AspectRatio(
                                    aspectRatio: 1,
                                    child: CommentCropPhoto(photoByte,
                                        StartX: 420,
                                        StartY: 107,
                                        EndX: 835,
                                        EndY: 520))),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20.0, top: 10.0, right: 20.0),
                              child: Text(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
                            ),
                            Divider(
                              color: Colors.greenAccent[400],
                            ),
                            Container(
                                child: Row(
                              children: [
                                IconButton(icon: Icon(Icons.favorite), onPressed: (){

                                },),
                                IconButton(icon: Icon(Icons.forward),onPressed: (){

                                }),
                              ],
                            ))
                          ],
                        ))),
                Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(14.0))),
                        child: Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: CircleIcon(
                                  url: "https://i.imgur.com/BoN9kdC.png"),
                              title: Text("Handsome"),
                              subtitle: Text("Comment at 31 Feb 2021 23:59"),
                            ),
                            Divider(
                              color: Colors.greenAccent[400],
                            ),
                            Container(
                                child: AspectRatio(
                                    aspectRatio: 1,
                                    child: CommentCropPhoto(photoByte,
                                        StartX: 172,
                                        StartY: 307,
                                        EndX: 585,
                                        EndY: 720))),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20.0, top: 10.0, right: 20.0),
                              child: Text(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
                            ),
                            Divider(
                              color: Colors.greenAccent[400],
                            ),
                            Container(
                                child: Row(
                                  children: [
                                    IconButton(icon: Icon(Icons.favorite)),
                                    IconButton(icon: Icon(Icons.forward)),
                                  ],
                                ))
                          ],
                        )))
              ]);
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ))),
    );
  }
}

//ImageProcess.encodeJpg(ImageProcess.copyCrop(ImageProcess.decodeJpg(photoByte),0 , 0, 200, 200))
