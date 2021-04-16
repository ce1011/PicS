import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:pics/page/register/Register_Page_DisplayName.dart';
import 'package:provider/provider.dart';
import '../../provider/RegisterInformationContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPageName extends StatelessWidget {
  final TextEditingController nameInputController = new TextEditingController();

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
            Builder(
              builder: (context)=> Container(
                child: RaisedButton(
                  child: Text("Next"),
                  onPressed: () async {

                    if(nameInputController.text == ""){
                      final snackBar =
                      SnackBar(content: Text('Username couid not be empty.'));
                      Scaffold.of(context).showSnackBar(snackBar);
                    }else{
                      QuerySnapshot sameUsername;
                      CollectionReference user =
                      FirebaseFirestore.instance.collection("user");
                      
                      await user.where('username', isEqualTo: nameInputController.text).get().then((value) => sameUsername = value);

                      if(sameUsername.size == 0){
                        Provider.of<RegisterInformationContainer>(context,
                            listen: false)
                            .setName(nameInputController.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPageDisplayName()),
                        );
                      }else{
                        final snackBar =
                        SnackBar(content: Text('This username have been chosen by another user.'));
                        Scaffold.of(context).showSnackBar(snackBar);
                      }

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
