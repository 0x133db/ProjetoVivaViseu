import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:vivaviseu/home.dart';

class FluroRouter {
  static Router router = Router();

  //static Handler alleventsHandler = Handler(handlerFunc: (BuildContext context,Map<String,dynamic> params) => AllEvents());

  static Handler homeHandler = Handler(handlerFunc: (BuildContext context,Map<String,dynamic> params) => HomeScreen());

  /*static void setupRouter(){
    router.define(
      'home',
      handler: homeHandler,
    );
  }*/


}