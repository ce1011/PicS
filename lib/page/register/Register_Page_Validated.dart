import 'package:flutter/material.dart';

class RegisterPageValidated extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Validated"),
        ),
        body: Center(
          child: Text("Please restart your app and login again."),
        ));
  }
}
