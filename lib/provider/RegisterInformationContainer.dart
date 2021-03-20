import 'package:flutter/foundation.dart';

class RegisterInformationContainer with ChangeNotifier {
  String email, userName, password, phoneno, displayName;

  setName(String name){
    this.userName = name;
  }

  setEmail(String email){
    this.email = email;
  }

  setPassword(String password){
    this.password = password;
  }

  setPhoneNo(String phoneno){
    this.phoneno = phoneno;
  }

  setDisplayName(String displayName){
    this.displayName = displayName;
  }

  String getName(){
    return userName;
  }

  String getEmail(){
    return email;
  }

  String getPassword(){
    return password;
  }

  String getPhoneNo(){
    return phoneno;
  }

  String getDisplayName(){
    return displayName;
  }
}
