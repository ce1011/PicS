import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'Register_Page_Name.dart';
import 'package:provider/provider.dart';
import '../../provider/RegisterInformationContainer.dart';

class RegisterPageEmail extends StatelessWidget {
  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  final TextEditingController emailInputController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Create Account")),
        body: Column(
          children: [
            Text(
              "Let us know your email",
              style: TextStyle(fontSize: 24),
            ),
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
                  controller: emailInputController,
                  //inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))],
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.alternate_email, color: Color(0xFF2308423)),
                    labelText: "E-mail",
                    enabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Color(0xFF2308423))),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: Colors.greenAccent[400])),
                  ),
                )),
            Builder(

              builder: (context)=>Container(
                child: RaisedButton(
                  child: Text("Next"),
                  onPressed: () {
                    if (!validateEmail(emailInputController.text)) {
                      final snackBar =
                          SnackBar(content: Text('The email is not valid.'));
                      Scaffold.of(context).showSnackBar(snackBar);
                    } else {
                      Provider.of<RegisterInformationContainer>(context,
                              listen: false)
                          .setEmail(emailInputController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPageName()),
                      );
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
