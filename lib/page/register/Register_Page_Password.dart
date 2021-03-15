import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pics/page/register/Register_Page_PhoneNo.dart';
import '../../provider/RegisterInformationContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPagePassword extends StatelessWidget {
  final TextEditingController passwordInputController =
  new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Password")),
        body: Column(
          children: [
            Text("Tell us the password", style: TextStyle(fontSize: 24)),
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
            Container(
              child: RaisedButton(
                child: Text("Next"),
                onPressed: () async {
                  Provider.of<RegisterInformationContainer>(context, listen: false).setPassword(passwordInputController.text);

                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: Provider.of<RegisterInformationContainer>(context, listen: false).getEmail(),
                      password: Provider.of<RegisterInformationContainer>(context, listen: false).getPassword()
                  );

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPagePhoneNo()),);
                },
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }
}
