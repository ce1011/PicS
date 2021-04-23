import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:pics/page/comment/View_Comment_Page.dart';

class VideoTrimmingPage extends StatefulWidget {
  String url, postID;

  VideoTrimmingPage({this.url, this.postID});

  @override
  _VideoTrimmingPageState createState() => _VideoTrimmingPageState();

  static _VideoTrimmingPageState of(BuildContext context) =>
      context.findAncestorStateOfType<_VideoTrimmingPageState>();
}

class _VideoTrimmingPageState extends State<VideoTrimmingPage> {
  FirebaseFunctions functions = FirebaseFunctions.instance;

  bool posting = false;

  int startTime, endTime;

  VideoPlayerController _videoController;
  ChewieController _chewieController;

  RangeValues _timeDurationRange = new RangeValues(0, 1);

  final TextEditingController commentInputController =
      new TextEditingController();

  Future<bool> loadVideo() async {
    print(widget.url);
    _videoController = new VideoPlayerController.network(widget.url);
    await _videoController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
    );

    return true;
  }

  Future<bool> postComment() async {
    var result;
    try {
      posting = true;
      setState(() {

      });
      await functions
          .httpsCallable('postVideoClipComment')
          .call(<String, dynamic>{
        'postID': widget.postID,
        'startTime': _timeDurationRange.start,
        'endTime': _timeDurationRange.end,
        'comment': commentInputController.text,
      }).then((value) => result = value.data['status']);

      if (result == "success") {
        return true;
      }
    } on FirebaseFunctionsException catch (e) {
      print(
          'Cloud functions exception with code: ${e.code}, and Details: ${e.details}, with message: ${e.message} ');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _chewieController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Trimming"),
        actions: [
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                if (await postComment() == true) {
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 2;
                  });

                  Navigator.pushNamed(
                      context, "/post/${widget.postID}/comment", arguments: CommentArguments(true));
                } else {
                  print("error");
                }
              })
        ],
      ),
      body: (!posting)? Container(
        child: FutureBuilder(
            future: loadVideo(),
            builder: (builder, snapshot) {
              if (snapshot.data == true) {
                _videoController.play();
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: Chewie(
                          key: Key("videoPreview"),
                          controller: _chewieController,
                        ),
                      ),
                      VideoRangeSlider(
                      postID: widget.postID,
                          chewieController: _chewieController,
                          controller: _timeDurationRange,
                          endTime: (_videoController.value.duration.inSeconds +
                              (_videoController.value.duration.inMinutes * 60) +
                              (_videoController.value.duration.inMilliseconds /
                                  1000 /
                                  60))),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Type your comment...',
                        ),
                        controller: commentInputController,
                        minLines: 6,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }),
      ) : Center(child: CircularProgressIndicator(),),
    );
  }
}

class VideoRangeSlider extends StatefulWidget {
  double endTime;
  RangeValues controller;
  ChewieController chewieController;
  String postID;

  VideoRangeSlider(
      {@required String postID,@required double this.endTime,
      @required RangeValues this.controller,
      @required ChewieController this.chewieController});

  @override
  _VideoRangeSliderState createState() => _VideoRangeSliderState();
}

class _VideoRangeSliderState extends State<VideoRangeSlider> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RangeSlider(
          values: widget.controller,
          min: 0.0,
          max: widget.endTime,
          onChanged: (value) {
            setState(() {
              VideoTrimmingPage.of(context)._timeDurationRange = value;
              widget.controller = value;
            });
          },
          labels: RangeLabels(
            widget.controller.start.toString(),
            widget.controller.end.toString(),
          ),
        ),
        Text(
            "Start: ${widget.controller.start.toStringAsFixed(2)} End: ${widget.controller.end.toStringAsFixed(2)} Length: ${(widget.controller.end - widget.controller.start).toStringAsFixed(2)}"),
        RaisedButton(
            child: Text("Trim"),
            onPressed: () {
              Duration startTime = new Duration(
                  seconds: widget.controller.start.floor(),
                  milliseconds: ((widget.controller.start -
                              widget.controller.start.floor()) *
                          1000)
                      .round());

              Duration endTime = new Duration(
                  seconds: widget.controller.end.floor(),
                  milliseconds:
                      ((widget.controller.end - widget.controller.end.floor()) *
                              1000)
                          .round());

              var pauseClip;

              widget.chewieController.seekTo(startTime);
              widget.chewieController.play();
              pauseClip = () {
                widget.chewieController.videoPlayerController.position
                    .then((value) => {
                          if (value.compareTo(endTime) > 0)
                            {
                              widget.chewieController.pause(),
                              widget.chewieController.videoPlayerController
                                  .removeListener(pauseClip)
                            }
                        });
              };

              if(!kIsWeb){
                widget.chewieController.videoPlayerController.addListener(pauseClip);
              }


              print("Start: " + startTime.toString());
              print("End: " + endTime.toString());
            }),
      ],
    );
  }
}
