import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'Register_Page_Name.dart';
import '../../provider/RegisterInformationContainer.dart';

class RegisterPagePhoneNo extends StatelessWidget {
  final TextEditingController phoneNoInputController =
  new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Pnone Number")),
        body: Column(
          children: [
            Text("Tell us the phone number", style: TextStyle(fontSize: 24)),
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
                controller: phoneNoInputController,
                //inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))],
                keyboardType: TextInputType.phone,
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
                child: Text("Next"),onPressed: (){
                Provider.of<RegisterInformationContainer>(context, listen: false).setPhoneNo(phoneNoInputController.text);
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPageName()),);
              },
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }
}
