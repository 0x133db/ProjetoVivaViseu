import 'dart:convert';
//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:vivaviseu/calendar.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:vivaviseu/eventdetails.dart';
import 'package:vivaviseu/favorites.dart';
import 'package:vivaviseu/login.dart';
import 'package:vivaviseu/main.dart';
import 'package:vivaviseu/objects.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluro/fluro.dart';
import 'dart:async';

int num = 0;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    HighlightedEvents(),
    Calendar(),
    Favorites(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 42, 54),
      body: Container(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 47, 59, 76),
          ),
          height: screenHeight / 15, //apagar
          width: screenWidth, //apagar
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: BottomNavigationBar(//Barra de navegação da App
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
                    icon: Icon(Icons.home),
                    label: 'Home',
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(Icons.event),
                    label: 'Calendar',
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                  //icon: Icon(Icons.favorite),
                  icon: Image.asset('assets/images/icons/icon_favorite.png'),
                  label: 'Favorites',
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HighlightedEvents extends StatefulWidget {
  HighlightedEvents({Key key}) : super(key: key);

  @override
  HighlightedEventsState createState() => HighlightedEventsState();
}

class HighlightedEventsState extends State<HighlightedEvents> {
  Future<List<Result>> eventosemdestaque; //lista de eventos em destaque
  int numeroeventos; //numero de eventos em destaque

  @override
  void initState() {
    super.initState();
    eventosemdestaque = loadData();
    numeroeventos = num;
    print(eventosemdestaque);
    print(numeroeventos);
  }

  Future<List<Result>> loadData() async {
    Uri eventosapiUrl =
        Uri.parse("http://vivaviseu.projectbox.pt/api/v1/highlighted_events");
    print('Link utilizado: $eventosapiUrl');
    var res = await http.get(eventosapiUrl);
    if (res.statusCode == 200) {
      Map<String, dynamic> bodyy = json.decode(res.body);
      Welcome teste = Welcome.fromMap(bodyy);
      print("lenght ${teste.result.length}");
      int i;
      for (i = 0; i < teste.result.length; i++) {
        print(
            '${teste.result[i].event.id} , ${teste.result[i].event.title} , Organizador: ${teste.result[i].event.organizer.name}');
      }
      num = teste.getListEvents().length;
      return teste.result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 34, 42, 54),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color.fromARGB(255, 47, 59, 76),
                ),
                child: TextField(
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    fillColor: Colors.black,
                    hintText: 'Pesquisar',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(1000)),
                        child: FlatButton(
                          onPressed: () {},
                          child: Text('Categoria 1'),
                          color: Color.fromRGBO(233, 168, 3, 1.0),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Text('Categoria 2'),
                        color: Color.fromRGBO(233, 168, 3, 1.0),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Text('Categoria 3'),
                        color: Color.fromRGBO(233, 168, 3, 1.0),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Text('Categoria 4'),
                        color: Color.fromRGBO(233, 168, 3, 1.0),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Scrollbar(
                          child: FlatButton(
                        onPressed: () {},
                        child: Text('Categoria 4'),
                        color: Color.fromRGBO(233, 168, 3, 1.0),
                      ))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Destaques',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                      ),
                    ),
                    TextButton(
                      //onPressed: Router_.router.navigateTo(context, '/'),
                      onPressed: (){
                        Router_.router.navigateTo(context, '/allevents');
                      },
                      child: Text(
                        'ver todos',
                        style: TextStyle(
                            color: Color.fromRGBO(233, 168, 3, 1.0),
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                dragStartBehavior: DragStartBehavior.start,
                scrollDirection: Axis.vertical,
                child: FutureBuilder(
                    future: loadData(),
                    // ignore: missing_return
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Container(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        case ConnectionState.done:
                          return SizedBox(
                            height: 500,
                            child: ListView.builder(
                                physics: ClampingScrollPhysics(),
                                itemCount: numeroeventos,
                                itemBuilder: (BuildContext context, int index) {
                                  var title = snapshot.data[index].event.title;
                                  var location =
                                      snapshot.data[index].event.location;
                                  //var startdate = snapshot.data[index].event.start_date;
                                  var image =
                                      'http://${snapshot.data[index].event.images[0].image.thumbnail}';
                                  print('$image');
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 0),
                                    child: Center(
                                        child: SizedBox(
                                            child: Stack(
                                                alignment: Alignment.centerLeft,
                                                children: [
                                          Container(
                                            color:
                                                Color.fromARGB(255, 34, 42, 54),
                                            height: 120,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 47, 59, 76),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
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
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    color: Colors.transparent,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    child: Image.network(
                                                      image,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('$title'),
                                                    Text('$location'),
                                                    //Text('${startdate.toString()}')
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ]))),
                                  );
                                }),
                          );
                        case ConnectionState.waiting:
                          return Container(
                            child: Center(child: CircularProgressIndicator()),
                          );
                      }
                    }),
              )
            ])));
  }
}

class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 42, 54),
      appBar: AppBar(
        toolbarHeight: 80.0,
        title: Text(
          "Favoritos",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 30.0,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 34, 42, 54),
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 40.0,
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('Aparência',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30.0,
                )),
            subtitle: Text('Temas e cores da aplicação'),
          ),
          SizedBox(
            height: 10.0,
          ),
          ListTile(
            leading: Icon(Icons.landscape_outlined),
            title: Text('Idioma',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30.0,
                )),
            subtitle: Text('Idioma da aplicação'),
          ),
          SizedBox(
            height: 10.0,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30.0,
                )),
            onTap: () {
              auth.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          )
        ],
      ),
    );
  }
}
