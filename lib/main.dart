//import 'dart:html';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:vivaviseu/config/routes.dart';
import 'package:vivaviseu/eventdetails.dart';
import 'package:vivaviseu/home.dart';
import 'package:vivaviseu/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  _AppState(){
      final FluroRouter router = FluroRouter();
      Routes.configureRoutes(router);
      Router_.router = router;
  }

  @override
  Widget build(BuildContext context) {
    var app = MaterialApp(
      title: 'Viva Viseu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.amberAccent,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: Router_.router.generator,
      //home: HomeScreen(),
    );
    return app;
  }
}

//Teste Firebase
/*class Home extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Erro!'),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                String result = 'Sucesso!',
                return Scaffold(
                  body: Center(
                    child: Text('Sucesso!'),
                  ),
                );
              }
              return Scaffold(
                body: Center(
                  child: Text('Loading!'),
                ),
              );
            }));
  }
}*/
