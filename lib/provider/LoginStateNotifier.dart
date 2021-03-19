import 'package:flutter/foundation.dart';

class LoginStateNotifier with ChangeNotifier {
  bool _login = false;
  String UID;
  String displayName, username;

  bool get loginState => _login;

  login(String UID) {
    _login = true;
    this.UID = UID;
    notifyListeners();
  }

  setUsername(String name){
    username = name;
    notifyListeners();
  }

  setDisplayName(String name){
    displayName = name;
    notifyListeners();
  }

  logout() {
    _login = false;
    notifyListeners();
  }
}
