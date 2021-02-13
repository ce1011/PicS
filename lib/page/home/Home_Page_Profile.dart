import 'package:flutter/material.dart';
import 'package:pics/component/Circle_Icon.dart';
import '../../provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import '../../component/Circle_Icon.dart';

class HomePageProfile extends StatefulWidget {
  @override
  _HomePageProfileState createState() => _HomePageProfileState();
}

class _HomePageProfileState extends State<HomePageProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
            padding: EdgeInsets.only(
                left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
            child: Card(
                elevation: 15.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14.0))),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: ListTile(
                        leading: CircleIcon(
                            url:
                                "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg"),
                        title: Text(Provider.of<LoginStateNotifier>(context,
                                listen: false)
                            .name),
                      ),
                    ),
                    ListTile(subtitle: Text("Lorem ipsum dolor sit amet"))
                  ],
                ))),
        RaisedButton(
          child: Text("Log Out"),
          onPressed: () {
            Navigator.popAndPushNamed(context, "/login");
          },
        )
      ],
    ));
  }
}
