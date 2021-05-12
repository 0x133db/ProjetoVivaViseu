import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivaviseu/objects.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  SharedPreferences sharedPreferences;
  List<Event> eventosfavoritos = [];

  @override
  void initState() {
    super.initState();
    //initSharedPreferences();
  }

  /*void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loaduserdata();
  }

  //Load Events list and decode to eventosfavoritos
  void loaduserdata() {
    setState(() {
      print('Loading Users Data...');
      List<String> spList = sharedPreferences.getStringList('usersfavorites');
      if (spList == null) {
        print('No Users Data!');
        return;
      } else {
        eventosfavoritos =
            spList.map((item) => Event.fromMap(json.decode(item))).toList();
        print('Data Loaded: [${eventosfavoritos}]');
      }
      print('Users Data Loaded!');
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 42, 54),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Favoritos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
                  color: Color.fromARGB(255, 34, 42, 54),
                  height: 20,
                  width: 400,
                  //teste
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: eventosfavoritos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 50,
                          child: Center(
                              child: Text('Entry ${eventosfavoritos[index]}', style: TextStyle(color: Colors.white),)),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
