import 'package:flutter/foundation.dart';

class LoginStateNotifier with ChangeNotifier {
  bool _login = false;
  int accountID;
  String name = "dick",account;

  bool get loginState => _login;

  login(String name) {
    _login = true;
    this.name = name;
    notifyListeners();
  }

  logout() {
    _login = false;
    notifyListeners();
  }
}
