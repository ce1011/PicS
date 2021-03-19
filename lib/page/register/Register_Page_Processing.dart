import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import '../../provider/RegisterInformationContainer.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../provider/LoginStateNotifier.dart';

class RegisterPageProcessing extends StatefulWidget {
  @override
  _RegisterPageProcessingState createState() => _RegisterPageProcessingState();
}

class _RegisterPageProcessingState extends State<RegisterPageProcessing> {
  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationId = "";

  ConfirmationResult confirmationResult;

  final TextEditingController validationCodeController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    register();
  }

  register() async {
    if(kIsWeb){
      confirmationResult = await auth.signInWithPhoneNumber(Provider.of<RegisterInformationContainer>(context, listen: false)
          .getPhoneNo(),);
    }else{
      await auth.verifyPhoneNumber(
        phoneNumber:
        Provider.of<RegisterInformationContainer>(context, listen: false)
            .getPhoneNo(),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY!

          // Sign the user in (or link) with the auto-generated credential
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {},
        codeSent: (String verificationId, int resendToken) async {
          this.verificationId = verificationId;
        },
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Pnone Number")),
        body: Column(
          children: [
            Text("Tell us the validation code", style: TextStyle(fontSize: 24)),
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
                controller: validationCodeController,
                //inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))],
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.vpn_key_outlined, color: Color(0xFF2308423)),
                  labelText: "Validation Code",
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Color(0xFF2308423))),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: Colors.greenAccent[400])),
                ),
              ),
            ),
            Container(
              child: Builder(
                builder: (context) =>
                    RaisedButton(
                      child: Text("Next"),
                      onPressed: () async {

                        String smsCode = validationCodeController.text;
                        bool pass = true;
                        if(kIsWeb){ //Process out of flutter
                          print(smsCode);
                          UserCredential userCredential = await confirmationResult.confirm(smsCode);

                          print(userCredential);

                          await auth.currentUser
                              .linkWithCredential(userCredential.credential);
                        }else{
                          try {
                            PhoneAuthCredential phoneAuthCredential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId, smsCode: smsCode);

                            // Sign the user in (or link) with the credential
                            await auth.currentUser
                                .linkWithCredential(phoneAuthCredential);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'credential-already-in-use') {
                              pass = false;
                              final snackBar = SnackBar(
                                  content: Text(
                                      'Phone Number have been use in other account.'));
                              Scaffold.of(context).showSnackBar(snackBar);
                            }else{
                              pass = false;
                              final snackBar = SnackBar(
                                  content: Text(
                                      'Other error'));
                              Scaffold.of(context).showSnackBar(snackBar);
                            }
                          }

                          if (pass == true) {
                            Provider.of<LoginStateNotifier>(context, listen: false)
                                .login(auth.currentUser.uid);
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/home', (route) => false);
                          }
                        }

                      }

                      //auth.currentUser.linkWithPhoneNumber("+85266429900").timeout(Duration(seconds: 10)).whenComplete(() => null);
                      ,
                    ),
            )
            )],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }
}
