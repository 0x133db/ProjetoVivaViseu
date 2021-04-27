import 'dart:ui';

import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 42, 54),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 1),
        child: Container(
          color: Colors.grey,
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
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
