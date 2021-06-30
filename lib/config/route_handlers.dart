import 'package:vivaviseu/adicionar_eventos_calendar.dart';
import 'package:vivaviseu/allevents.dart';
import 'package:vivaviseu/detalhesevento.dart';
import 'package:vivaviseu/eventdetails.dart';

import 'package:vivaviseu/home.dart';
import 'package:flutter/painting.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:vivaviseu/listagemgeral.dart';
import 'package:vivaviseu/objects.dart';

//Ir para homescreen
var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return HomeScreen();
});

//Ir para todos eventos
var alleventsHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return AllEvents();
});

//Ir para listagemgeral
var listagemgeralHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
            String? categoryid = params["categoryid"]?.first;
            String? tobesearched = params["text"]?.first;
            if(categoryid != null){return ListagemGeral(categoryid: int.parse(categoryid));}
            if(tobesearched != null){return ListagemGeral(searchtext: tobesearched);}            
  return ListagemGeral();
});

var listagemgeralpesquisaHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
            String? tobesearched = params["text"]?.first;
            if(tobesearched != null){return ListagemGeral(searchtext: tobesearched);}            
  return ListagemGeral();}
);

//Ir para Detalhes de Evento
/*var eventdetailsHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      String? eventoid = params["eventoid"]?.first;
      String? favorite = params["favorite"]?.first;
  return EventDetails(eventid: int.parse(eventoid!));
});*/

var eventdetailsHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      String? eventoid = params["eventoid"]?.first;
      String? favorite = params["favorite"]?.first;
  return DetalhesEvento(id: int.parse(eventoid!),);
});

