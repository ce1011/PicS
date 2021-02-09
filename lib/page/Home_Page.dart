import 'package:flutter/material.dart';
import 'home/Home_Page_Post.dart';
import 'home/Home_Page_Profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedHomePage = 0;
  List<Widget> widgetList = <Widget>[HomePagePost(), HomePageProfile()];

  void onTap(int index) {
    setState(() {
      selectedHomePage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("PicS",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent[400]))),
      body: Center(child: widgetList.elementAt(selectedHomePage)),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: "Post"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
        currentIndex: selectedHomePage,
        onTap: onTap,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Color(0xFF212121),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () {
          print("dick");
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
