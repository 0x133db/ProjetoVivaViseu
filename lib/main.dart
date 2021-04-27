//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vivaviseu/eventdetails.dart';
import 'package:vivaviseu/home.dart';
import 'package:vivaviseu/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor: Colors.amberAccent,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

//Teste
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
