import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BrightnessNotifier with ChangeNotifier {
  Brightness brightnessState = Brightness.dark;

  changeBrightnessState() {
    if(brightnessState == Brightness.dark){
      brightnessState = Brightness.light;
    }else{
      brightnessState = Brightness.dark;
    }

    notifyListeners();
  }
}
