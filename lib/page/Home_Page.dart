import 'package:flutter/material.dart';
import 'package:pics/page/home/Home_Page_CreatePost.dart';
import 'home/Home_Page_Post.dart';
import 'home/Home_Page_Profile.dart';
import 'home/Home_Page_Search.dart';
import 'home/Home_Page_CreatePost.dart';
import 'createClip/pickImage.dart';
import '../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import 'chat/Select_Chat_Page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedHomePage = 0;
  List<Widget> widgetList = <Widget>[
    HomePagePost(),
    HomePageSearch(),
    HomePageProfile()
  ];

  void onTap(int index) {
    setState(() {
      selectedHomePage = index;
    });
  }

  @override
  void initState() {
    super.initState();

    Future(() {
      final snackBar = SnackBar(
        content: Text("Signed in as " +
            Provider.of<LoginStateNotifier>(context, listen: false).name),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1, milliseconds: 500),
      );
      if (Provider.of<LoginStateNotifier>(context, listen: false).loginState ==
          true) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PicS",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        actions: [
          IconButton(
              icon: Icon(Icons.chat),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectChatPage()),
                );
              })
        ],
      ),
      body: Container(
          padding: EdgeInsets.only(
            left: (MediaQuery.of(context).size.width >= 1080.0)
                ? (MediaQuery.of(context).size.width) * 0.25
                : (MediaQuery.of(context).size.width) * 0.04,
            right: (MediaQuery.of(context).size.width >= 1080.0)
                ? (MediaQuery.of(context).size.width) * 0.25
                : (MediaQuery.of(context).size.width) * 0.04,
          ),
          child: widgetList.elementAt(selectedHomePage)),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.post_add), label: "Post"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ],
          currentIndex: selectedHomePage,
          onTap: onTap,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          elevation: 0),
      floatingActionButton: (selectedHomePage == 0 && Provider.of<LoginStateNotifier>(context, listen: false).loginState ==
          true) ? FloatingActionButton(
        child: Icon(Icons.post_add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PickImagePage()),
          );
        },
      ): null,
    );
  }
}
