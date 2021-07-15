import 'dart:collection';
import 'dart:convert';
//import 'dart:ffi';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vivaviseu/calendar.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:vivaviseu/favorites.dart';
import 'package:vivaviseu/highlightedevents.dart';
import 'package:vivaviseu/main.dart';
import 'package:vivaviseu/objects.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluro/fluro.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivaviseu/utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool pageview = true;
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    HighlightedEvents(),
    Calendar(),
    Favorites(),
  ];

  void pageChanged(int index) {
  setState(() {
    _selectedIndex = index;
  });
}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

PageController pageController = PageController(
  initialPage: 0,
  keepPage: true,
);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 34, 42, 54),
        body:Container(child: _widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(25),
          child: Container(
            height: SizeConfig.heightMultiplier! * 7.5,
            width: SizeConfig.maxWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color.fromARGB(255, 47, 59, 76),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: BottomNavigationBar(
                //Barra de navegação da App
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: Color.fromARGB(255, 47, 59, 76),
                currentIndex: _selectedIndex,
                unselectedItemColor: Colors.grey[400],
                selectedItemColor: Color.fromARGB(255, 233, 168, 3),
                iconSize: 25,
                onTap: _onItemTapped,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/images/icons/icon_home.png',
                                              height: 2.9 * SizeConfig.heightMultiplier!,
                      ),
                      activeIcon: Image.asset(
                        'assets/images/icons/icon_home_colored.png',
                        height: 2.9 * SizeConfig.heightMultiplier!,
                      ),
                      label: 'Home',
                      backgroundColor: Colors.white),
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/images/icons/icon_calendar.png',
                                              height: 2.9 * SizeConfig.heightMultiplier!,
                      ),
                      activeIcon: Image.asset(
                        'assets/images/icons/icon_calendar_colored.png',
                        height: 2.9 * SizeConfig.heightMultiplier!,
                      ),
                      label: 'Calendar',
                      backgroundColor: Colors.white),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/icons/icon_favoritemenu.png',
                                            height: 2.9 * SizeConfig.heightMultiplier!,
                    ),
                    activeIcon: Image.asset(
                      'assets/images/icons/icon_favoritemenu_colored.png',
                      height: 2.9 * SizeConfig.heightMultiplier!,
                    ),
                    label: 'Favorites',
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EventContainerWidget extends StatelessWidget {
  const EventContainerWidget({
    Key? key,
    required this.image,
    required this.title,
    required this.location,
    required this.id,
  }) : super(key: key);

  final String image;
  final String title;
  final String location;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Center(
          child: SizedBox(
              child: Stack(alignment: Alignment.centerLeft, children: [
        Container(
          color: Color.fromARGB(255, 34, 42, 54),
          height: 120,
        ),
        Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 47, 59, 76),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          height: 90,
          width: 400,
        ),
        Row(
          children: [
            Stack(children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.transparent,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Stack(children: [
                    Stack(
                        //Stack de Widgets para fazer o efeito da imagem do evento
                        children: [
                          Container(
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ]),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          child: GestureDetector(
                            onTap: () {
                              /*addeventtofavorites(snapshot
                                          .data[
                                              index]
                                          .event);*/
                            },
                            child: ClipOval(
                              child: Material(
                                color: Colors.grey,
                                child: Image.asset(
                                  'assets/images/icons/icon_favorites.png',
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$title'),
                  Text('$location'),
                  //Text('${formattedDate.toString()}')
                ],
              ),
            ),
          ],
        )
      ]))),
    );
  }
}
