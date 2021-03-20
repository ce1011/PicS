import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:pics/page/register/Register_Page_DisplayName.dart';
import 'package:provider/provider.dart';
import '../../provider/RegisterInformationContainer.dart';

class RegisterPageName extends StatelessWidget {
  final TextEditingController nameInputController =
  new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Username")),
        body: Column(
          children: [
            Text("What is your wished username?",
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
                  controller: nameInputController,
                  //inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))],
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Name",
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
                  Provider.of<RegisterInformationContainer>(context, listen: false).setName(nameInputController.text);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPageDisplayName()),);
                },
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }
}
