import 'package:flutter/material.dart';
import 'package:vivaviseu/utils/responsive.dart';

class AppTheme {
  AppTheme._();

  static const Color appBackgroundColor = Color.fromARGB(255, 34, 42, 54);
  static const Color appEventContainerColor = Color.fromARGB(255, 47, 59, 76);
    static const Color appaccentColor = Color.fromRGBO(233, 168, 3, 1.0);

  static final ThemeData appTheme = ThemeData(
    scaffoldBackgroundColor: AppTheme.appBackgroundColor,
    accentColor: AppTheme.appaccentColor,
    textTheme: TextStyleTheme,
  );

  /*static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    textTheme: darkTextTheme,
  );*/
  /////////////////////////////////////////////////////
  ///
  ///Meus
  ///
  ///
  
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

  /////////////////////////////////////////////////////

  /*static final TextTheme lightTextTheme = TextTheme(
    title: _titleLight,
    subtitle: _subTitleLight,
    button: _buttonLight,
    display1: _greetingLight,
    display2: _searchLight,
    body1: _selectedTabLight,
    body2: _unSelectedTabLight,
  );

  static final TextTheme darkTextTheme = TextTheme(
    title: _titleDark,
    subtitle: _subTitleDark,
    button: _buttonDark,
    display1: _greetingDark,
    display2: _searchDark,
    body1: _selectedTabDark,
    body2: _unSelectedTabDark,
  );*/

  /*

  static final TextStyle _titleLight = TextStyle(
    color: Colors.black,
    fontSize: 3.5 * SizeConfig.textMultiplier!,
  );

  static final TextStyle _subTitleLight = TextStyle(
    color: subTitleTextColor,
    fontSize: 2 * SizeConfig.textMultiplier!,
    height: 1.5,
  );

  static final TextStyle _buttonLight = TextStyle(
    color: Colors.black,
    fontSize: 2.5 * SizeConfig.textMultiplier!,
  );

  static final TextStyle _greetingLight = TextStyle(
    color: Colors.black,
    fontSize: 2.0 * SizeConfig.textMultiplier!,
  );

  static final TextStyle _searchLight = TextStyle(
    color: Colors.black,
    fontSize: 2.3 * SizeConfig.textMultiplier!,
  );

  static final TextStyle _selectedTabLight = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 2 * SizeConfig.textMultiplier!,
  );

  static final TextStyle _unSelectedTabLight = TextStyle(
    color: Colors.grey,
    fontSize: 2 * SizeConfig.textMultiplier!,
  );

  static final TextStyle _titleDark = _titleLight.copyWith(color: Colors.white);

  static final TextStyle _subTitleDark = _subTitleLight.copyWith(color: Colors.white70);

  static final TextStyle _buttonDark = _buttonLight.copyWith(color: Colors.black);

  static final TextStyle _greetingDark = _greetingLight.copyWith(color: Colors.black);

  static final TextStyle _searchDark = _searchDark.copyWith(color: Colors.black);

  static final TextStyle _selectedTabDark = _selectedTabDark.copyWith(color: Colors.white);

  static final TextStyle _unSelectedTabDark = _selectedTabDark.copyWith(color: Colors.white70);*/
}