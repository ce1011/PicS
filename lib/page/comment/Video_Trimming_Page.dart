import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

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

  Future<bool> postComment() async{
    var result;
    try{
      await functions.httpsCallable('postVideoClipComment').call(<String, dynamic>{'postID': widget.postID,'startTime': _timeDurationRange.start, 'endTime': _timeDurationRange.end, 'comment' : commentInputController.text, }).then((value) => result= value);

      print(result.data);
  } on FirebaseFunctionsException catch  (e) {
  print('Cloud functions exception with code: ${e.code}, and Details: ${e.details}, with message: ${e.message} ');
  } catch (e) {
  print(e.toString());
  }

    return false;
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
                } else {
                  print("error");
                }
              })
        ],
      ),
      body: Container(
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
      ),
    );
  }
}

class VideoRangeSlider extends StatefulWidget {
  double endTime;
  RangeValues controller;
  ChewieController chewieController;

  VideoRangeSlider(
      {@required double this.endTime,
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
            "Start: ${widget.controller.start.toString()} End: ${widget.controller.end.toString()} Length: ${widget.controller.end - widget.controller.start}"),
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

              widget.chewieController.videoPlayerController
                  .addListener(pauseClip);

              print("Start: " + startTime.toString());
              print("End: " + endTime.toString());
            }),
      ],
    );
  }
}
