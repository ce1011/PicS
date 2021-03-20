import 'package:flutter/foundation.dart';

class LoginStateNotifier with ChangeNotifier {
  bool _login = false;
  String UID;
  String displayName, username, description;

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

  setDescription(String description){
    this.description = description;
    notifyListeners();
  }

  getDescription(){
    return description;
  }

  getUsername(){
    return username;
  }

  getDisplayName(){
    return displayName;
  }

  logout() {
    _login = false;
    notifyListeners();
  }

  getUID(){
    return UID;
  }
}
