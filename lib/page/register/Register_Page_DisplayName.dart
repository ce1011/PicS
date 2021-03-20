import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:pics/page/register/Register_Page_Password.dart';
import 'package:provider/provider.dart';
import '../../provider/RegisterInformationContainer.dart';

class RegisterPageDisplayName extends StatelessWidget {
  final TextEditingController displayNameInputController =
  new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Display Name")),
        body: Column(
          children: [
            Text("What is your wished display name?",
                style: TextStyle(fontSize: 24)),
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
              child: Container(
                padding: EdgeInsets.only(
                    left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
                child: TextField(
                  controller: displayNameInputController,
                  //inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))],
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Display Name",
                    enabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Color(0xFF2308423))),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                        new BorderSide(color: Colors.greenAccent[400])),
                  ),
                ),
              ),
            ),
            Container(
              child: RaisedButton(
                child: Text("Next"),
                onPressed: () {
                  Provider.of<RegisterInformationContainer>(context, listen: false).setDisplayName(displayNameInputController.text);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPagePassword()),);
                },
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }
}
