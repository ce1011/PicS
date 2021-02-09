import 'package:flutter/material.dart';

class HomePageProfile extends StatefulWidget {
  @override
  _HomePageProfileState createState() => _HomePageProfileState();
}

class _HomePageProfileState extends State<HomePageProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: RaisedButton(
      child: Text("Log Out"),
      onPressed: () {
        Navigator.popAndPushNamed(context, "/login");
      },
    ));
  }
}
