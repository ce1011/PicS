import 'package:flutter/material.dart';
import 'provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import 'page/Login_Page.dart';
import 'page/Home_Page.dart';
import 'page/register/Register_Page_Email.dart';
import 'page/register/Register_Page_Password.dart';
import 'page/register/Register_Page_Name.dart';
import 'page/register/Register_Page_Processing.dart';


Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: LoginStateNotifier())],
      child: MaterialApp(
          title: 'PicS',
          theme: ThemeData(
            brightness: Brightness.dark,
            accentColor: Colors.greenAccent[400],
            buttonColor: Colors.greenAccent[400],
            primaryColor: Colors.greenAccent[400],
          ),
          home: LoginPage(),
          routes: {
            "/home": (context) => HomePage(),
            "/login": (context) => LoginPage(),
            "/register": (context) => RegisterPageEmail(),
          }),
    );
  }
}
