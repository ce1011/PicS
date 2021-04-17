import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class VideoCallPage extends StatefulWidget {
  String UID, targetUID;
  int mode;
  DocumentReference watchChatContentDocument;

  VideoCallPage(this.UID, this.mode,
      {this.targetUID, this.watchChatContentDocument});

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  bool mic =true, video=true;
  InAppWebViewController _webViewController;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.mode == 0) {
      widget.watchChatContentDocument.snapshots().listen((event) {
        print(event.data().toString());
        if (event.data()['result'] == "accept") {
          print("accept");
          //_webViewController.evaluateJavascript(source: "startCall('" + widget.targetUID + "')");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Video Call"),
          actions: [IconButton(icon: Icon(Icons.connect_without_contact), onPressed: (){
            _webViewController.evaluateJavascript(source: "startCall('" + widget.targetUID + "')");
          }),IconButton(icon: Icon(Icons.mic), onPressed: (){
            mic = !mic;
            _webViewController.evaluateJavascript(source: "toggleAudio('" + mic.toString() + "')");
            if(mic == true){
              final snackBar = SnackBar(
                  content:
                  Text('Turn On Microphone'));
              Scaffold.of(context).showSnackBar(snackBar);

            }else{
              final snackBar = SnackBar(
                  content:
                  Text('Turn Off Microphone'));
              Scaffold.of(context).showSnackBar(snackBar);
            }

          }), IconButton(icon: Icon(Icons.camera), onPressed: (){
            video = !video;
            _webViewController.evaluateJavascript(source: "toggleVideo('" + video.toString() + "')");
            if(mic == true){
              final snackBar = SnackBar(
                  content:
                  Text('Turn On Camera'));
              Scaffold.of(context).showSnackBar(snackBar);

            }else{
              final snackBar = SnackBar(
                  content:
                  Text('Turn Off Camera'));
              Scaffold.of(context).showSnackBar(snackBar);
            }
          })],
        ),
        body: Container(
            child: InAppWebView(
                initialFile: "assets/call.html",
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                  // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
                },
                onLoadStop: (controller, url) {
                  _webViewController.evaluateJavascript(source: "init('" + widget.UID + "')");
                },
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    mediaPlaybackRequiresUserGesture: false,
                  ),
                ),
                androidOnPermissionRequest: (InAppWebViewController controller,
                    String origin, List<String> resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                })));
  }
}

// _controller.webViewController.evaluateJavascript("startCall('"+widget.targetUID+"')");
//_controller.webViewController.evaluateJavascript("init('"+widget.UID+"')");
