import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class RegisterPageName extends StatelessWidget {
  TextEditingController email, password, firstName, lastName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Name")),
        body: Column(
          children: [
            Text("What is your name?", style: TextStyle(fontSize: 24)),
            Container(
                width: 200,
                height: 200,
                child: FlareActor(
                  'assets/animation/register.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "go",
                )),
            Container(
              padding: EdgeInsets.only(
                  left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                          decoration: InputDecoration(
                            labelText: "First Name",
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                new BorderSide(color: Color(0xFF2308423))),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                new BorderSide(color: Colors.greenAccent[400])),
                          )),
                      flex: 6),
                  Spacer(flex: 1),
                  Expanded(
                      child: TextField(
                          decoration: InputDecoration(
                            labelText: "Last Name",
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                new BorderSide(color: Color(0xFF2308423))),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                new BorderSide(color: Colors.greenAccent[400])),
                          )),
                      flex: 6)
                ],
              ),
            ),
            Container(
              child: RaisedButton(
                child: Text("Next"),onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, "/register/processing", (route) => false);
              },
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }
}
