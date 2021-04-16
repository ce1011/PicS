import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VideoCallPage extends StatefulWidget {
  String UID, targetUID;

  VideoCallPage(this.UID, this.targetUID);

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  InAppWebViewController webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Video Call"),
        ),
        body: Container(
            child: InAppWebView(
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    mediaPlaybackRequiresUserGesture: false,
                  ),
                ),
                initialFile: "assets/call.html",
                onWebViewCreated: (controller) {
                  webViewController = controller;

                  webViewController.addJavaScriptHandler(
                      handlerName: "getVideoCallContent",
                      callback: (args) {
                        return {
                          'UID': widget.UID,
                          'targetUID': widget.targetUID
                        };
                      });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
                androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
                  return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                }
            )));
  }
}
