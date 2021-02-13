import 'package:flutter/material.dart';
import 'provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import 'page/Login_Page.dart';
import 'page/Home_Page.dart';
import 'page/register/Register_Page_Email.dart';
import 'page/register/Register_Page_Password.dart';
import 'page/register/Register_Page_Name.dart';
import 'page/register/Register_Page_Processing.dart';
import 'page/comment/View_Comment_Page.dart';
import 'package:responsive_framework/responsive_framework.dart';


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
          builder: (context, widget) => ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, widget),
              maxWidth: 3440,
              minWidth: 450,
              defaultScale: true,
              breakpoints: [
                ResponsiveBreakpoint.resize(480, name: MOBILE),
                ResponsiveBreakpoint.autoScale(800, name: TABLET),
                ResponsiveBreakpoint.resize(1000, name: DESKTOP),
              ],
              background: Container(color: Color(0xFFF5F5F5))),
          title: 'PicS',
          theme: ThemeData(
            brightness: Brightness.dark,
            accentColor: Colors.greenAccent[400],
            buttonColor: Colors.greenAccent[400],
            primaryColor: Colors.greenAccent[400],
          ),
          home: HomePage(),
          routes: {
            "/home": (context) => HomePage(),
            "/login": (context) => LoginPage(),
            "/register/email": (context) => RegisterPageEmail(),
            "/register/password": (context) => RegisterPagePassword(),
            "/register/name": (context) => RegisterPageName(),
            "/register/processing": (context) => RegisterPageProcessing(),
          }),
    );
  }
}
