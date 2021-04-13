import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pics/page/register/Register_Page_PhoneNo.dart';
import 'package:pics/page/register/Register_Page_Validated.dart';

class RegisterEmailVerifyPage extends StatefulWidget {
  @override
  _RegisterEmailVerifyPageState createState() => _RegisterEmailVerifyPageState();
}

class _RegisterEmailVerifyPageState extends State<RegisterEmailVerifyPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    auth.signOut();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Initial State UID: " + auth.currentUser.uid + " emailVerify: " +auth.currentUser.email + " " + auth.currentUser.emailVerified.toString());

    if(!auth.currentUser.emailVerified && !auth.currentUser.isAnonymous){
      print("send email");
      auth.currentUser.sendEmailVerification();
    }else{
      print("email not send");
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Email Verification"),
        ),
        body: Column(
          children: [
            Center(
              child: Text(
                  "An email has been sent to you. Please enter your email and verify your email"),
            ),
            RaisedButton(onPressed: (){
              FirebaseAuth auth = FirebaseAuth.instance;

              if(auth.currentUser.phoneNumber == null){
                print("No Phone");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPagePhoneNo()));
              }else{
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPageValidated()),
                        (route) => false);
              }
            }, child: Text("I have verifiy my email"),)
          ],
        ));
  }
}
