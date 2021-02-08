import 'package:flutter/foundation.dart';

class LoginStateNotifier with ChangeNotifier {
  bool _login = false;
  int accountID;
  String name,account;


  bool get loginState => _login;

  login() {
    _login = true;
    notifyListeners();
  }

  logout() {
    _login = false;
    notifyListeners();
  }
}
