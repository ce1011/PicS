import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import '../../provider/RegisterInformationContainer.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPageProcessing extends StatefulWidget {
  @override
  _RegisterPageProcessingState createState() => _RegisterPageProcessingState();
}

class _RegisterPageProcessingState extends State<RegisterPageProcessing> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState(){
    super.initState();
    register();
  }

  register() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: Provider.of<RegisterInformationContainer>(context, listen: false).getEmail(),
          password: Provider.of<RegisterInformationContainer>(context, listen: false).getPassword()
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        final snackBar = SnackBar(
            content:
            Text('The password provided is too weak.'));
        Scaffold.of(context).showSnackBar(snackBar);
      } else if (e.code == 'email-already-in-use') {
        final snackBar = SnackBar(
            content:
            Text('The account already exists for that email.'));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e);
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Text("Processing", style: TextStyle(fontSize: 24)),
            Container(
                width: 500,
                height: 500,
                child: FlareActor(
                  'assets/animation/login.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "Untitled",
                )),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }
}

