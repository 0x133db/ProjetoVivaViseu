import 'package:flutter/material.dart';
import 'package:vivaviseu/utils/responsive.dart';

class AppTheme {
  AppTheme._();

  static const Color appBackgroundColor = Color.fromARGB(255, 34, 42, 54);
  static const Color appEventContainerColor = Color.fromARGB(255, 47, 59, 76);
    static const Color appaccentColor = Color.fromRGBO(233, 168, 3, 1.0);

  static final ThemeData appTheme = ThemeData(
    primaryColor: Color.fromRGBO(233, 168, 3, 1),
    scaffoldBackgroundColor: AppTheme.appBackgroundColor,
    accentColor: AppTheme.appaccentColor,
    textTheme: TextStyleTheme,
  );
  
  static final TextTheme TextStyleTheme = TextTheme(
    headline1: pageTitle,
    ///////Containers de Informaçoes de Eventos (Listagens)
    headline2: containerInfo, // titulo de evento container -> containers de informaçoes de eventos
    caption: containerInfoCaption, //localizaçao e data -> containers de informaçoes de eventos
    ///////Página de Detalhes de Eventos
    headline3: detailsTitle, // tituloS de página de detalhes evento
    headline4: detailsRegular, // regular text pagina de detalhes evento
    subtitle1: verTodosText,
  );

  static final TextStyle pageTitle = TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            letterSpacing: SizeConfig.textMultiplier!* 0.06,
            fontSize: 3.2 * SizeConfig.textMultiplier!,
  );

    static final TextStyle containerInfo = TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 1.6 * SizeConfig.textMultiplier!,
  );

      static final TextStyle containerInfoCaption = TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal,
            fontSize: 1.4 * SizeConfig.textMultiplier!,
  );

      static final TextStyle detailsTitle = TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 2.8 * SizeConfig.textMultiplier!,
  );

        static final TextStyle detailsRegular = TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal,
            fontSize: 1.7 * SizeConfig.textMultiplier!,
  );

      static final TextStyle verTodosText = TextStyle(
            color: Color.fromRGBO(233, 168, 3, 1),
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal,
            fontSize: 1.5 * SizeConfig.textMultiplier!,
  );
}