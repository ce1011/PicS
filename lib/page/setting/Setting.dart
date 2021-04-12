import 'package:flutter/material.dart';
import '../../provider/BrightnessNotifier.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Setting")),
        body: SwitchListTile(
          title: Text("Dark Mode"),
          onChanged: (value) {
            Provider.of<BrightnessNotifier>(context, listen: false)
                .toggle(value);
          },
          value:
              Provider.of<BrightnessNotifier>(context, listen: true).darkMode,
        ));
  }
}
