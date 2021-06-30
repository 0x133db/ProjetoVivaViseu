import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import './route_handlers.dart';

class Routes {
  static String root = "/";
  static String allevents = "/allevents";
  static String eventdetails = "/eventdetails";
  static String listagemgeral = "/listagemgeral";
  static String listagemgeralpesquisa = "/listagemgeralpesquisa";
  static String addeventdevicecalendar = "/addeventdevicecalendar";
  /*static String demoSimple = "/demo";
  static String demoSimpleFixedTrans = "/demo/fixedtrans";
  static String demoFunc = "/demo/func";
  static String deepLink = "/message";*/

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(root, handler: rootHandler);
    router.define(allevents,
        handler: alleventsHandler, transitionType: TransitionType.inFromLeft);
    router.define(listagemgeral,
        handler: listagemgeralHandler,
        transitionType: TransitionType.inFromLeft);
    router.define(listagemgeralpesquisa,
        handler: listagemgeralpesquisaHandler,
        transitionType: TransitionType.inFromLeft);
    router.define(eventdetails,
        handler: eventdetailsHandler,
        transitionType: TransitionType.inFromRight);
  }
}
