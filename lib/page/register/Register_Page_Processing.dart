import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class RegisterPageProcessing extends StatefulWidget {
  @override
  _RegisterPageProcessingState createState() => _RegisterPageProcessingState();
}

class _RegisterPageProcessingState extends State<RegisterPageProcessing> {
  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 5),
            () => Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Text("Processing", style: TextStyle(fontSize: 24)),
            Container(
                width: 500,
                height: 500,
                child: FlareActor(
                  'assets/animation/login.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "Untitled",
                )),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }
}

