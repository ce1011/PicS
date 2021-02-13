import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import '../provider/LoginStateNotifier.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController accountInputController =
      new TextEditingController();
  final TextEditingController passwordInputController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
      builder: (context) => Column(
        children: <Widget>[
          Text.rich(TextSpan(
              text: 'Log in to ',
              style: TextStyle(fontSize: 28),
              children: [
                TextSpan(
                    text: "PicS",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent[400]))
              ])),
          Container(
            width: 200,
            height: 200,
            child: FlareActor(
              "assets/animation/connection.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "conn",
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
            child: TextField(
              key: ObjectKey("email"),
              controller: accountInputController,
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.alternate_email, color: Color(0xFF2308423)),
                labelText: "E-mail",
                enabledBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Color(0xFF2308423))),
                focusedBorder: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.greenAccent[400])),
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.only(
                  left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
              child: TextField(
                key: ObjectKey("password"),
                controller: passwordInputController,
                decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.vpn_key_outlined, color: Color(0xFF2308423)),
                    labelText: "Password",
                    enabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Color(0xFF2308423))),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: Colors.greenAccent[400]))),
              )),
          RaisedButton(
            onPressed: () {
              Provider.of<LoginStateNotifier>(context, listen: false)
                  .login(accountInputController.text);
              Navigator.pushReplacementNamed(context, "/home");
            },
            child: Text("Login", style: TextStyle(color: Colors.black)),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/home");
            },
            child: Text("Just looking around", style: TextStyle(color: Colors.black)),
          ),
          Row(
            children: [
              Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/register/email");
                },
                child: Text("Sign Up",
                    style: TextStyle(
                        color: Colors.greenAccent[400], fontSize: 15)),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    ));
  }
}
