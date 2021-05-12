import 'package:vivaviseu/allevents.dart';
import 'package:vivaviseu/eventdetails.dart';

import 'package:vivaviseu/home.dart';
import 'package:flutter/painting.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

//Ir para homescreen
var rootHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return HomeScreen();
});

//Ir para ...
var alleventsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AllEvents();
});

//Ir para Detalhes de Evento
var eventdetailsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String eventoid = params["eventoid"]?.first;
  return EventDetails(eventid: int.parse(eventoid));
});
