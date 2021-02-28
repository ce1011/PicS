import 'package:flutter/foundation.dart';

class RegisterInformationContainer with ChangeNotifier {
  String email, name, password, phoneno;

  setName(String name){
    this.name = name;
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

  String getName(){
    return name;
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
}
