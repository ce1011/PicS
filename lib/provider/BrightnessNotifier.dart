import 'package:flutter/foundation.dart';

class BrightnessNotifier with ChangeNotifier {
  bool darkMode = true;

  toggle(value) {
    darkMode = value;
    notifyListeners();
  }
}
