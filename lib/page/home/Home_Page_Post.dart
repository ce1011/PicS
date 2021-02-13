import 'package:flutter/material.dart';
import '../../component/Circle_Icon.dart';
import '../comment/View_Comment_Page.dart';

class HomePagePost extends StatefulWidget {
  @override
  _HomePagePostState createState() => _HomePagePostState();
}

//(MediaQuery.of(context).size.width) * 0.25
class _HomePagePostState extends State<HomePagePost> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          left: (MediaQuery.of(context).size.width >= 1080.0)
              ? (MediaQuery.of(context).size.width) * 0.25
              : (MediaQuery.of(context).size.width) * 0.04,
          right: (MediaQuery.of(context).size.width >= 1080.0)
              ? (MediaQuery.of(context).size.width) * 0.25
              : (MediaQuery.of(context).size.width) * 0.04,
        ),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14.0))),
                    child: Column(
                      children: [
                        ListTile(
                          dense: true,
                          leading: CircleIcon(
                              url: "https://i.imgur.com/BoN9kdC.png"),
                          title: Text("DLLM"),
                          subtitle: Text("Posted at 31 Feb 2021 23:59"),
                        ),
                        Divider(
                          color: Colors.greenAccent[400],
                        ),
                        Container(
                            child: Image.network(
                                "https://images.pexels.com/photos/2246476/pexels-photo-2246476.jpeg")),
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
                            IconButton(
                              icon: Icon(Icons.comment),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewCommentPage()),
                                );
                              },
                            ),
                            IconButton(icon: Icon(Icons.forward)),
                          ],
                        ))
                      ],
                    ))),
            Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14.0))),
                    child: Column(
                      children: [
                        ListTile(
                          dense: true,
                          leading: CircleIcon(
                              url: "https://i.imgur.com/BoN9kdC.png"),
                          title: Text("DLLM"),
                          subtitle: Text("Posted at 31 Feb 2021 23:59"),
                        ),
                        Divider(
                          color: Colors.greenAccent[400],
                        ),
                        Container(
                            child: Image.network(
                                "https://cdn.wallpaperhub.app/cloudcache/1/b/5/8/e/f/1b58ef6e3d36a42e01992accf5c52d6eea244353.jpg")),
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
                            IconButton(icon: Icon(Icons.comment)),
                            IconButton(icon: Icon(Icons.forward)),
                          ],
                        ))
                      ],
                    )))
          ],
        )));
  }
}
