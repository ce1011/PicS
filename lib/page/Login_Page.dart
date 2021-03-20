import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import '../provider/LoginStateNotifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register/Register_Page_PhoneNo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController accountInputController =
      new TextEditingController();
  final TextEditingController passwordInputController =
      new TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    auth.authStateChanges().listen((User user) {
      if (user.phoneNumber == null && !auth.currentUser.isAnonymous) {
        print("No phone");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => RegisterPagePhoneNo()),
            (route) => false);
      } else if (!auth.currentUser.isAnonymous) {
        FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

        CollectionReference profile = firestoreInstance.collection("user");
        profile
            .where('UID', isEqualTo: user.uid)
            .get()
            .then((data) => {
                  Provider.of<LoginStateNotifier>(context, listen: false)
                      .setDisplayName(data.docs[0].data()['displayName']),
                  Provider.of<LoginStateNotifier>(context, listen: false)
                      .setUsername(data.docs[0].data()['username']),
          Provider.of<LoginStateNotifier>(context, listen: false)
              .setDescription(data.docs[0].data()['description'])
                })
            .then((value) =>
                Provider.of<LoginStateNotifier>(context, listen: false)
                    .login(user.uid))
            .then((value) => Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false));
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    });

    return Scaffold(
        body: Builder(
            builder: (context) => Container(
                  padding: EdgeInsets.only(
                    left: (MediaQuery.of(context).size.width >= 1080.0)
                        ? (MediaQuery.of(context).size.width) * 0.3
                        : (MediaQuery.of(context).size.width) * 0.04,
                    right: (MediaQuery.of(context).size.width >= 1080.0)
                        ? (MediaQuery.of(context).size.width) * 0.3
                        : (MediaQuery.of(context).size.width) * 0.04,
                  ),
                  child: Column(
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
                        width: (MediaQuery.of(context).size.width >= 1080.0)
                            ? 500
                            : 250,
                        height: (MediaQuery.of(context).size.width >= 1080.0)
                            ? 500
                            : 250,
                        child: FlareActor(
                          "assets/animation/connection.flr",
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          animation: "conn",
                        ),
                      ),
                      Container(
                        child: TextField(
                          key: ObjectKey("email"),
                          controller: accountInputController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.alternate_email,
                                color: Color(0xFF2308423)),
                            labelText: "E-mail",
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Color(0xFF2308423))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.greenAccent[400])),
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              top: (MediaQuery.of(context).size.height) * 0.01,
                              bottom:
                                  (MediaQuery.of(context).size.height) * 0.01),
                          child: TextField(
                            key: ObjectKey("password"),
                            controller: passwordInputController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.vpn_key_outlined,
                                    color: Color(0xFF2308423)),
                                labelText: "Password",
                                enabledBorder: OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xFF2308423))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Colors.greenAccent[400]))),
                          )),
                      Container(
                        padding: EdgeInsets.only(
                          top: (MediaQuery.of(context).size.height >= 1080.0)
                              ? (MediaQuery.of(context).size.height) * 0.005
                              : 0,
                          bottom: (MediaQuery.of(context).size.height >= 1080.0)
                              ? (MediaQuery.of(context).size.height) * 0.01
                              : 0,
                        ),
                        child: RaisedButton(
                          onPressed: () async {
                            try {
                              UserCredential userCredential =
                                  await auth.signInWithEmailAndPassword(
                                      email: accountInputController.text,
                                      password: passwordInputController.text);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                final snackBar = SnackBar(
                                    content:
                                        Text('No user found for that email.'));
                                Scaffold.of(context).showSnackBar(snackBar);
                              } else if (e.code == 'wrong-password') {
                                final snackBar = SnackBar(
                                    content: Text(
                                        'Wrong password provided for that user.'));
                                Scaffold.of(context).showSnackBar(snackBar);
                              }
                            }
                          },
                          child: Text("Login",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: (MediaQuery.of(context).size.height >= 1080.0)
                              ? (MediaQuery.of(context).size.height) * 0.005
                              : 0,
                          bottom: (MediaQuery.of(context).size.height >= 1080.0)
                              ? (MediaQuery.of(context).size.height) * 0.01
                              : 0,
                        ),
                        child: RaisedButton(
                          onPressed: () {
                            print(MediaQuery.of(context).size.height);
                            print(MediaQuery.of(context).size.width);
                            print(MediaQuery.of(context).devicePixelRatio);
                            auth.signInAnonymously();
                          },
                          child: Text("Just looking around",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      Row(
                        children: [
                          Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/register");
                            },
                            child: Text("Sign Up",
                                style: TextStyle(
                                    color: Colors.greenAccent[400],
                                    fontSize: 15)),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                )));
  }
}
