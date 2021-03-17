import 'package:flutter/foundation.dart';

class LoginStateNotifier with ChangeNotifier {
  bool _login = false;
  String UID;
  String name = "dick",account;

  bool get loginState => _login;

  login(String name, String UID) {
    _login = true;
    this.name = name;
    this.UID = UID;
    notifyListeners();
  }

  logout() {
    _login = false;
    notifyListeners();
  }
}
