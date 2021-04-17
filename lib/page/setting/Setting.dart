import 'package:flutter/material.dart';
import '../../provider/BrightnessNotifier.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingPage extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Setting")),
        body: Container(
          padding: EdgeInsets.only(
            left: (MediaQuery.of(context).size.width >= 1080.0)
                ? (MediaQuery.of(context).size.width) * 0.25
                : 0,
            right: (MediaQuery.of(context).size.width >= 1080.0)
                ? (MediaQuery.of(context).size.width) * 0.25
                : 0,
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: Text("Dark Mode"),
                onChanged: (value) {
                  Provider.of<BrightnessNotifier>(context, listen: false)
                      .toggle(value);
                },
                value: Provider.of<BrightnessNotifier>(context, listen: true)
                    .darkMode,
              ),
              ListTile(
                title: Text("Delete Account (Not Finish))"),
                onTap: () async {
                  HttpsCallable callable =
                      FirebaseFunctions.instance.httpsCallable('deleteAccount');
                  final results = await callable();

                  if (results.data['status'] == "success") {
                    auth.signOut();
                  }
                },
              )
            ],
          ),
        ));
  }
}
