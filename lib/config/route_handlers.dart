import 'package:vivaviseu/allevents.dart';

import 'package:vivaviseu/home.dart';
import 'package:flutter/painting.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

//Ir para homescreen
var rootHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return HomeScreen();
});

var alleventsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AllEvents();
});

