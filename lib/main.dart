import 'package:flutter/material.dart';
import 'provider/LoginStateNotifier.dart';
import 'provider/RegisterInformationContainer.dart';
import 'provider/BrightnessNotifier.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluro/fluro.dart';
import 'route/routes.dart';
import 'route/application.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: LoginStateNotifier()),
    ChangeNotifierProvider.value(value: RegisterInformationContainer()),
    ChangeNotifierProvider.value(value: BrightnessNotifier()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp() {
    final router = FluroRouter();
    Routes.defineRoutes(router);
    Application.router = router;
  }

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
          return MaterialApp(
            title: 'PicS',
            theme: Provider.of<BrightnessNotifier>(context, listen: true)
                    .darkMode
                ? ThemeData(
                    brightness: Brightness.dark,
                    accentColor: Colors.greenAccent[400],
                    scaffoldBackgroundColor: Colors.black,
                    colorScheme: ColorScheme.dark(),
                    dividerColor: Colors.greenAccent[400],
                    bottomAppBarColor: Colors.black,
                    buttonColor: Colors.greenAccent[400],
                    floatingActionButtonTheme: FloatingActionButtonThemeData(
                        backgroundColor: Colors.greenAccent[400]),
                    appBarTheme: AppBarTheme(backgroundColor: Colors.black),
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      backgroundColor: Colors.black,
                    ),
                    canvasColor: Colors.black,
                dialogTheme: DialogTheme(backgroundColor: Colors.black,),
                  )
                : ThemeData(
                    brightness: Brightness.light,
                    accentColor: Colors.greenAccent[400],
                    primaryColor: Colors.greenAccent[400],
                    dividerColor: Colors.greenAccent[400],
                    buttonColor: Colors.greenAccent[400],
                  ),
            onGenerateRoute: Application.router.generator,
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
