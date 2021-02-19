import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class PickImagePage extends StatefulWidget {
  @override
  _PickImagePageState createState() => _PickImagePageState();
}

class _PickImagePageState extends State<PickImagePage> {
  Uint8List _image;
  final picker = ImagePicker();

  Future getImageFromGallery() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);

    setState(() {
      if (result != null) {
        PlatformFile file = result.files.first;
        _image = file.bytes;
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        print(pickedFile.path);
        _image = File(pickedFile.path).readAsBytesSync();
      } else {
        print('No image selected.');
      }
    });
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
            IconButton(
                icon: Icon(Icons.add_a_photo), onPressed: getImageFromCamera)
          ],
        ),
        body: Column(
          children: [
            Center(
              child: _image == null
                  ? Text('No image selected.')
                  : Image.memory(_image),
            )
          ],
        ));
  }
}
