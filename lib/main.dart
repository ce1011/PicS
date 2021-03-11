import 'package:flutter/material.dart';
import 'provider/LoginStateNotifier.dart';
import 'provider/RegisterInformationContainer.dart';
import 'package:provider/provider.dart';
import 'page/Login_Page.dart';
import 'page/Home_Page.dart';
import 'page/register/Register_Page_Email.dart';
import 'package:firebase_core/firebase_core.dart';
import 'page/register/Register_Page_Password.dart';
import 'page/register/Register_Page_Name.dart';
import 'page/register/Register_Page_Processing.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Error");
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: LoginStateNotifier()),
              ChangeNotifierProvider.value(
                  value: RegisterInformationContainer()),
            ],
            child: MaterialApp(
                title: 'PicS',
                theme: ThemeData(
                    brightness: Brightness.dark,
                    accentColor: Colors.greenAccent[400],
                    //primaryColor: Colors.greenAccent[400],
                    scaffoldBackgroundColor: Colors.black,
                    colorScheme: ColorScheme.dark(),
                    dividerColor: Colors.greenAccent[400],
                    //cardColor: Colors.black,
                    bottomAppBarColor: Colors.black,
                    buttonColor: Colors.greenAccent[400],
                    floatingActionButtonTheme: FloatingActionButtonThemeData(

                        backgroundColor: Colors.greenAccent[400]),
                    appBarTheme: AppBarTheme(backgroundColor: Colors.black),
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      backgroundColor: Colors.black,
                    )),
                home: LoginPage(),
                routes: {
                  "/home": (context) => HomePage(),
                  "/login": (context) => LoginPage(),
                  "/register": (context) => RegisterPageEmail(),
                  "/register/processing": (context) => RegisterPageProcessing(),
                }),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
