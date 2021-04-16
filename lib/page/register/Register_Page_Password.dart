import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pics/page/register/Register_Page_EmailVerify.dart';
import '../../provider/RegisterInformationContainer.dart';
import '../../provider/LoginStateNotifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPagePassword extends StatelessWidget {
  final TextEditingController passwordInputController =
  new TextEditingController();

  bool checkPasswordPattern(String password){
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(password)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Password")),
        body: Column(
          children: [
            Text("Tell us the password", style: TextStyle(fontSize: 24)),
            Text("The password must contain:"),
          Text("At least 1 Uppercase letter"),
            Text("At least 1 Lowercase letter"),
            Text("At least 1 numeric letter"),
            Text("At least 8 char long"),
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
              child: TextField(
                controller: passwordInputController,
                //inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon:
                  Icon(Icons.vpn_key_outlined, color: Color(0xFF2308423)),
                  labelText: "Password",
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Color(0xFF2308423))),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                      new BorderSide(color: Colors.greenAccent[400])),
                ),
              ),
            ),
            Builder(
              builder: (context)=>Container(
                child: RaisedButton(
                  child: Text("Next"),
                  onPressed: () async {

                    if(!checkPasswordPattern(passwordInputController.text)){
                      final snackBar =
                      SnackBar(content: Text('The password is not match with requirment.'));
                      Scaffold.of(context).showSnackBar(snackBar);
                    }else{
                      Provider.of<RegisterInformationContainer>(context,
                          listen: false)
                          .setPassword(passwordInputController.text);

                      CollectionReference user =
                      FirebaseFirestore.instance.collection("user");

                      UserCredential userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                          email: Provider.of<RegisterInformationContainer>(
                              context,
                              listen: false)
                              .getEmail(),
                          password: Provider.of<RegisterInformationContainer>(
                              context,
                              listen: false)
                              .getPassword());
                      FirebaseFirestore.instance.collection("groupDB/" +
                          userCredential.user.uid +
                          "/groups").doc('friends').set({'ableForPostPermissionManagement': true,'UID':{}});

                      FirebaseFirestore.instance.collection("groupDB/" +
                          userCredential.user.uid +
                          "/groups").doc('waitForAccept').set({'UID':{}});

                      FirebaseFirestore.instance.collection("groupDB/" +
                          userCredential.user.uid +
                          "/groups").doc('waitForTargetUserAccept').set({'UID':{}});

                      await userCredential.user.sendEmailVerification();

                      await user.add({
                        'UID': userCredential.user.uid,
                        'displayName': Provider.of<RegisterInformationContainer>(
                            context,
                            listen: false)
                            .getDisplayName(),
                        'username': Provider.of<RegisterInformationContainer>(
                            context,
                            listen: false)
                            .getName(),
                        'description': ""
                      }).then(
                              (value) =>
                              Provider.of<LoginStateNotifier>(context,
                                  listen: false)
                                  .setDisplayName(
                                  Provider.of<RegisterInformationContainer>(context,
                                      listen: false)
                                      .getDisplayName())).then((value) =>
                          Provider.of<LoginStateNotifier>(context, listen: false)
                              .setUsername(
                              Provider.of<RegisterInformationContainer>(context,
                                  listen: false)
                                  .getName()));
                    }


                  },
                ),
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }
}

