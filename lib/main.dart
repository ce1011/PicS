import 'package:flutter/material.dart';
import 'provider/LoginStateNotifier.dart';
import 'package:provider/provider.dart';
import 'page/Login_Page.dart';
import 'page/register/Register_Page_Email.dart';
import 'page/register/Register_Page_Password.dart';
import 'page/register/Register_Page_Name.dart';
import 'page/register/Register_Page_Processing.dart';

void main() {
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
          ),
          home: LoginPage(),
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

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String account;

  HomePage({Key key, String account}) : super(key: key) {
    this.account = account;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text("PicS")),
        body: Column(
          children: [
            RaisedButton(
              onPressed: () {
                print(Provider.of<LoginStateNotifier>(context, listen: false)
                    .loginState);
              },
              child: Text("Check State"),
            ),
            RaisedButton(
              onPressed: () {
                Provider.of<LoginStateNotifier>(context, listen: false)
                    .logout();

                Navigator.popAndPushNamed(context, "/login");
              },
              child: Text("Log Off"),
            ),
          ],
        ));
  }
}

class Agent extends StatefulWidget {
  @override
  _AgentState createState() => _AgentState();
}

class _AgentState extends State<Agent> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        print(
            Provider.of<LoginStateNotifier>(context, listen: false).loginState);
      },
      child: Text("Check State"),
    );
  }
}
