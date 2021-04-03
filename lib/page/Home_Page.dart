import 'package:flutter/material.dart';
import 'home/Home_Page_Post.dart';
import 'home/Home_Page_Profile.dart';
import 'createClip/pickImage.dart';
import '../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import 'chat/Select_Chat_Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'setting/Setting.dart';
import 'setting/Setting_Group_List_Page.dart';
import '../component/Circle_Icon.dart';
import 'friends/View_Friend.dart';
import 'friends/View_Wait_For_Accept.dart';
import '../firebase/Firebase_User_Data_Agent.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUserDataAgent firebaseUserDataAgent = FirebaseUserDataAgent();
  FirebaseAuth auth = FirebaseAuth.instance;
  int selectedHomePage = 0;
  List<Widget> widgetList = <Widget>[HomePagePost(), HomePageProfile()];

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
            Provider.of<LoginStateNotifier>(context, listen: false)
                .displayName),
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
          (Provider.of<LoginStateNotifier>(context, listen: false).loginState ==
                  true)
              ? IconButton(
                  icon: Icon(Icons.chat),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelectChatPage()),
                    );
                  })
              : Container()
        ],
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            leading: FutureBuilder(
              future: firebaseUserDataAgent.getUserIconURL(Provider.of<LoginStateNotifier>(context, listen: false).UID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CircleIcon(url: snapshot.data);
                } else {
                  return Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('photo/emptyusericon.jpg'))),
                  );
                }
              },
            ),
            title: Text(Provider.of<LoginStateNotifier>(context, listen: false)
                .displayName),
            subtitle: Text(
                Provider.of<LoginStateNotifier>(context, listen: false)
                    .username),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Friends'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewFriendPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Wait For Accept'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewWaitForAcceptPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Permission Setting'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingGroupListPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Setting'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              auth.signOut();
              Provider.of<LoginStateNotifier>(context, listen: false).logout();
              Navigator.popAndPushNamed(context, "/");
            },
          )
        ],
      )),
      body: Container(
          padding: EdgeInsets.only(
            left: (MediaQuery.of(context).size.width >= 1080.0)
                ? (MediaQuery.of(context).size.width) * 0.25
                : 0,
            right: (MediaQuery.of(context).size.width >= 1080.0)
                ? (MediaQuery.of(context).size.width) * 0.25
                : 0,
          ),
          child: widgetList.elementAt(selectedHomePage)),
      bottomNavigationBar:
          (Provider.of<LoginStateNotifier>(context, listen: false).loginState ==
                  true)
              ? BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Icon(Icons.post_add), label: "Post"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.person), label: "Profile")
                    ],
                  currentIndex: selectedHomePage,
                  onTap: onTap,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  type: BottomNavigationBarType.fixed,
                  elevation: 0)
              : null,
      floatingActionButton:
          (Provider.of<LoginStateNotifier>(context, listen: false).loginState ==
                  true)
              ? FloatingActionButton(
                  child: Icon(
                    Icons.post_add,
                    color: Colors.grey[900],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PickImagePage()),
                    );
                  },
                )
              : FloatingActionButton(
                  child: Icon(
                    Icons.logout,
                    color: Colors.grey[900],
                  ),
                  onPressed: () {
                    auth.signOut();
                    Provider.of<LoginStateNotifier>(context, listen: false)
                        .logout();
                    Navigator.popAndPushNamed(context, "/");
                  },
                ),
      floatingActionButtonLocation:
          (Provider.of<LoginStateNotifier>(context, listen: false).loginState ==
                  true)
              ? FloatingActionButtonLocation.centerDocked
              : FloatingActionButtonLocation.endFloat,
    );
  }
}
