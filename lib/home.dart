import 'dart:collection';
import 'dart:convert';
//import 'dart:ffi';

import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vivaviseu/allevents.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivaviseu/searching.dart';

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
                    ),
                    activeIcon: Image.asset(
                      'assets/images/icons/icon_home_colored.png',
                    ),
                    label: 'Home',
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/icons/icon_calendar.png',
                    ),
                    activeIcon: Image.asset(
                      'assets/images/icons/icon_calendar_colored.png',
                    ),
                    label: 'Calendar',
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/icons/icon_favoritemenu.png',
                  ),
                  activeIcon: Image.asset(
                    'assets/images/icons/icon_favoritemenu_colored.png',
                  ),
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
  HighlightedEvents({Key? key}) : super(key: key);

  @override
  HighlightedEventsState createState() => HighlightedEventsState();
}

class CategoriaWidget extends StatelessWidget {
  CategoriaWidget({Key? key, this.categorianome}) : super(key: key);
  String? categorianome;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(1000)),
      child: FlatButton(
        onPressed: () {},
        child: Text('$categorianome'),
        color: Color.fromRGBO(233, 168, 3, 1.0),
      ),
    );
  }
}

class HighlightedEventsState extends State<HighlightedEvents> {
  List<Result>? eventosemdestaque; //lista de eventos em destaque
  late int numeroeventos; //numero de eventos em destaque
  int? numerocategorias; //numero de categorias

  late SharedPreferences userpreferences;
  List<String>? eventosFavoritos = [];

  bool seeall = false;
  bool searching = false;
  bool teste = true;
  String searchtext = '';

  @override
  void initState() {
    print('[---------- Página Eventos em Destaque ----------]');
    super.initState();
    initSharedPreferences();
  }

  Future<List<Result>?> loadData() async {
    Uri eventosapiUrl =
        Uri.parse("http://vivaviseu.projectbox.pt/api/v1/highlighted_events");
    print('Link utilizado para Eventos em Destaque: $eventosapiUrl');
    var resposta = await http.get(eventosapiUrl);
    if (resposta.statusCode == 200) {
      Map<String, dynamic> body = json.decode(resposta.body);
      Welcome Data = Welcome.fromMap(body);
      print("Número de Eventos em Destaque: ${Data.result!.length}");
      int i;
      for (i = 0; i < Data.result!.length; i++) {
        print(
            'Evento: [ID:${Data.result![i].event!.id}] , Título: ${Data.result![i].event!.title} , Organizador: ${Data.result![i].event!.organizer!.name}');
      }
      numeroeventos = Data.getListEvents()!.length;
      eventosemdestaque = Data.result;
      return eventosemdestaque;
    }
  }

  Future<List<CategoryCategory>?> loadCategories() async {
    Uri categoriesapiUrl =
        Uri.parse("http://vivaviseu.projectbox.pt/api/v1/categories");
    print('Link utilizado para Categorias: $categoriesapiUrl');
    var resposta = await http.get(categoriesapiUrl);
    if (resposta.statusCode == 200) {
      Map<String, dynamic> body = json.decode(resposta.body);
      List<CategoryCategory> listaCategorias = [];
      numerocategorias = body['result'].length;
      for (int i = 0; i < body['result'].length; i++) {
        CategoryCategory category =
            CategoryCategory.fromMap(body['result'][i]['category']);
        print('${category.name}');
        listaCategorias.add(category);
      }
      return listaCategorias;
    }
  }

  void search(String content) async {
    Uri searchapiUrl = Uri.parse(
        "http://vivaviseu.projectbox.pt/api/v1/events?page=1&category=1&organizer=1&query=$content");
    print('Link utilizado para Eventos em Destaque: $searchapiUrl');
    var resposta = await http.get(searchapiUrl);
    if (resposta.statusCode == 200) {
      Map<String, dynamic> body = json.decode(resposta.body);
      Welcome Data = Welcome.fromMap(body);
      print("Número de resultados de pesquisa: ${Data.result!.length}");
      for (int i = 0; i < Data.result!.length; i++) {
        print(
            '#Evento: [ID:${Data.result![i].event!.id}] , Título: ${Data.result![i].event!.title} , Organizador: ${Data.result![i].event!.organizer!.name}');
      }
    }
  }

//Users Favorite Events Data Functions
//

  void initSharedPreferences() async {
    //SharedPreferences.setMockInitialValues(<String, dynamic>{'favoritos':[]});
    print('########### Loading Users Data... ###########');
    loadUserData();
    print('########### Users Data Loaded... $eventosFavoritos ###########');
  }
  
  loadUserData()async{
    userpreferences = await SharedPreferences.getInstance();
    if (userpreferences.getStringList('favoritos') == null) {
      return;
    }
    eventosFavoritos = userpreferences.getStringList('favoritos');    
    print('Load User Data : $eventosFavoritos');
  }

  saveUserData(){
    userpreferences.setStringList('favoritos', eventosFavoritos!);      
    loadUserData();
    print('Saved User Data : $eventosFavoritos');
  }

  addEventUserData(int? id){
    print('Add Event User Data : $eventosFavoritos');
    if(eventosFavoritos!.contains(id.toString())){
      print('After add Event User Data : $eventosFavoritos');
      removeEventUserData(id);
      return;
    }
    eventosFavoritos!.add(id.toString());
    saveUserData();
    print('After add Event User Data : $eventosFavoritos');
  }

  removeEventUserData(int? id){
    print('Remove Event User Data : $eventosFavoritos');
    eventosFavoritos!.remove(id.toString());
    saveUserData();
    loadUserData();
    print('After Remove Event User Data : $eventosFavoritos');

  }

  Widget _getIconFavorite(int? id) {
    loadUserData();
    String string = id.toString();
    if(eventosFavoritos != null && eventosFavoritos!.contains(string)){
      return Image.asset(
        'assets/images/icons/icon_favorites.png',
        scale: 2,);
    }else{
      return Image.asset(
        'assets/images/icons/icon_favorite.png',
        scale: 1.5,);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (seeall == true) {
      return AllEvents();
    } else if (searching == true) {
      return SearchWidget();
    } else {
      return Scaffold(
          backgroundColor: Color.fromARGB(255, 34, 42, 54),
          body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 10, 35, 0),
                  child: Container(
                    height: 50,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color.fromARGB(255, 47, 59, 76),
                    ),
                    child:
                        /*TextField(
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      fillColor: Colors.black,
                      hintText: 'Pesquisar',
                    ),
                  ),*/
                        AnimatedSearchBar(
                      label: "Pesquisar",
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(152, 176, 210, 1),
                      ),
                      searchStyle: TextStyle(
                        color: Color.fromRGBO(152, 176, 210, 1),
                      ),
                      searchDecoration: InputDecoration(
                        icon: Image.asset(
                            'assets/images/icons/icon_searchicon.png'),
                        //border: InputBorder.none
                      ),
                      onChanged: (value) {
                        setState(() {
                          searching = !searching;
                          searchtext = value;
                          search(searchtext);
                        });
                      },
                    ),
                  ),
                ),
                //Barra de Categorias
                Padding(
                    padding: const EdgeInsets.fromLTRB(35, 20, 35, 0),
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 30,
                              child: FutureBuilder(
                                  future: loadCategories(),
                                  builder:
                                      // ignore: missing_return
                                      (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                        return Container(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        );
                                      case ConnectionState.waiting:
                                        return Container(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        );
                                      case ConnectionState.done:
                                        return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: numerocategorias,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var categoryname =
                                                  snapshot.data[index].name;
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: Container(
                                                  width: 110,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                100)),
                                                    child: TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          teste = !teste;
                                                        });
                                                      },
                                                      child: Text(
                                                        '$categoryname',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      style: ButtonStyle(
                                                          backgroundColor: teste == true
                                                              ? MaterialStateProperty.all<Color>(
                                                                  Color.fromRGBO(
                                                                      233,
                                                                      168,
                                                                      3,
                                                                      1.0))
                                                              : MaterialStateProperty.all<Color>(
                                                                  Color.fromARGB(
                                                                      255,
                                                                      47,
                                                                      59,
                                                                      76)),
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ))),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      case ConnectionState.active:
                                        return Container(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        );
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 20, 35, 0),
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
                      GestureDetector(
                        onTap: () {
                          //Router_.router.navigateTo(context, '/allevents');
                          setState(() {
                            seeall = !seeall;
                          });
                        },
                        child: Text(
                          'ver todos',
                          style: TextStyle(
                              color: Color.fromRGBO(233, 168, 3, 1.0),
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Container(
                    height: 470,
                    child: FutureBuilder(
                        future: loadData(),
                        // ignore: missing_return
                        builder:
                            // ignore: missing_return
                            (BuildContext context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Container(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            case ConnectionState.done:
                              return CarouselSlider.builder(
                                itemCount: numeroeventos,
                                itemBuilder:
                                    (BuildContext context, int index, int why) {
                                  // ignore: unused_local_variable
                                  var event = snapshot.data[index].event;
                                  var eventid = snapshot.data[index].event.id;
                                  var title = snapshot.data[index].event.title;
                                  var location =
                                      snapshot.data[index].event.location;
                                  var startdate =
                                      snapshot.data[index].event.startDate;
                                  var formattedDate =
                                      "${startdate.day}-${startdate.month}-${startdate.year}";
                                  var timeevent = snapshot.data[index].event
                                      .dates[0].date.timeStart;
                                  var time =
                                      "${timeevent.hour}h${timeevent.minute}";
                                  var image =
                                      'http://${snapshot.data[index].event.images[0].image.original}';
                                  var category = snapshot.data[index].event
                                      .categories[0].category.name;
                                  return GestureDetector(
                                    onTap: () {
                                      Router_.router.navigateTo(context,
                                          '/eventdetails?eventoid=$eventid');
                                    },
                                    child: Container(
                                      height: 900,
                                      width: 400,
                                      child: SingleChildScrollView(
                                        child: Card(
                                          elevation: 5,
                                          shadowColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.red,
                                                  Colors.black,
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              //color: Colors.black,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    image,
                                                  ),
                                                  fit: BoxFit.cover),
                                            ),
                                            child: Column(
                                              //coluna de widgets sobre a imagem
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/icons/icon_ellipse.png',
                                                            scale: 1.2,
                                                          ),
                                                          IconButton(
                                                            icon: /*Image.asset(
                                                              'assets/images/icons/icon_favorites.png',
                                                              scale: 2,
                                                            ),*/
                                                            _getIconFavorite(eventid),
                                                            onPressed: () {
                                                              setState(() {
                                                                //addeventtofavorites(event);
                                                                addEventUserData(eventid);
                                                              });
                                                            },
                                                          ),
                                                        ]),
                                                  ],
                                                ),
                                                SizedBox(height: 300),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 10, 15, 10),
                                                  child: Container(
                                                    width: 200,
                                                    height: 80,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        //Desenho de Categoria
                                                        Container(
                                                          width: 85,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      233,
                                                                      168,
                                                                      3,
                                                                      1),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                          child: Center(
                                                            child: Text(
                                                              category,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 11),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          title,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/icons/icon_eventdetailscalendar.png',
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              formattedDate,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Image.asset(
                                                              'assets/images/icons/icon_eventdetailswatch.png',
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              time,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/icons/icon_eventdetailslocation.png',
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              location,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                  height: 450,
                                  aspectRatio: 1,
                                  enlargeCenterPage: true,
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.scale,
                                  autoPlay: true,
                                  autoPlayCurve: Curves.easeInOut,
                                  enableInfiniteScroll: false,
                                  disableCenter: true,
                                ),

                                /*ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  itemCount: numeroeventos,
                                  itemBuilder: (BuildContext context, int index) {
                                    var eventid = snapshot.data[index].event.id;
                                    var title = snapshot.data[index].event.title;
                                    var location =
                                        snapshot.data[index].event.location;
                                    var startdate =
                                        snapshot.data[index].event.startDate;
                                    var formattedDate =
                                        "${startdate.day}-${startdate.month}-${startdate.year}";
                                    var image =
                                        'http://${snapshot.data[index].event.images[0].image.thumbnail}';
                                    return GestureDetector(
                                      onTap: (){Router_.router.navigateTo(context, '/eventdetails?eventoid=$eventid');},
                                      child: EventContainerWidget(image: image, title: title, location: location, id: eventid,));
                                  }),*/
                              );
                            case ConnectionState.waiting:
                              return Container(
                                height: 400,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            case ConnectionState.active:
                              return Container(
                                height: 400,
                                child: Center(
                                  child: Text('Active'),
                                ),
                              );
                          }
                        }),
                  ),
                )
              ])));
    }
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

/*
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
*/