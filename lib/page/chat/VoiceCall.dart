import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class VoiceCallPage extends StatefulWidget {
  String UID, targetUID;
  int mode;
  DocumentReference watchChatContentDocument;

  VoiceCallPage(this.UID, this.mode,
      {this.targetUID, this.watchChatContentDocument});

  @override
  _VoiceCallPageState createState() => _VoiceCallPageState();
}

class _VoiceCallPageState extends State<VoiceCallPage> {
  bool mic =true, video=false;
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
          _webViewController.evaluateJavascript(source: "startCall('" + widget.targetUID + "')");
        }else if (event.data()['result'] == "decline"){
          Navigator.pop(context);
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
                  _webViewController.evaluateJavascript(source: "toggleVideo('" + video.toString() + "')");
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
