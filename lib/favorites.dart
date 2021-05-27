import 'dart:convert';
import 'dart:ui';
import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:vivaviseu/objects.dart';
import 'package:http/http.dart' as http;

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late SharedPreferences userpreferences;
  List<String>? eventosFavoritos = [];
  List<Event?> eventosFavLista = [];
  String url = '';
  int numerofavoritos = 0;

  @override
  void initState() {
    print('[---------- Página Favoritos ----------]');

    super.initState();
    initSharedPreferences();
    //loadEventFromUserData();
  }

  void initSharedPreferences() async {
    userpreferences = await SharedPreferences.getInstance();
    //loadUserData();
  }

  //Load Events id to eventosfavoritos
  loadUserData() async {
    userpreferences = await SharedPreferences.getInstance();
    if (userpreferences.getStringList('favoritos') == null) {
      return;
    }
    eventosFavoritos = userpreferences.getStringList('favoritos');
    print('Load User Data : $eventosFavoritos');
  }

  saveUserData() {
    userpreferences.setStringList('favoritos', eventosFavoritos!);
    loadUserData();
    print('Saved User Data : $eventosFavoritos');
  }

  //order list events by date
  orderListEvents(List<Event?> list) {
    print('A ordernar Eventos');
    int size = list.length;
    Event? aux;
    for (int i = 0; i < size - 1; i++) {
      if (list[i + 1]!.startDate!.isBefore(list[i]!.startDate!)) {
        aux = list[i];
        list[i] = list[i + 1];
        list[i + 1] = aux;
      }
    }
  }

  //get events from user favorites and gets them from api
  Future<List<Event?>?> loadEventFromUserData() async {
    await loadUserData();
    print('Loaded User Data : \n $eventosFavoritos');
    numerofavoritos = 0;
    eventosFavLista.clear();
    String url = 'http://vivaviseu.projectbox.pt/api/v1/events?event_list=';
    for (var i = 0; i < eventosFavoritos!.length; i++) {
      int getid = int.parse(eventosFavoritos![i]);
      url = url + '$getid,';
    }
    if (url == 'http://vivaviseu.projectbox.pt/api/v1/events?event_list=') {
      return null;
    }
    Uri eventosfavoritosurl = Uri.parse(url);
    print('Link utilizado para Eventos Favoritos: $eventosfavoritosurl');
    var resposta = await http.get(eventosfavoritosurl);
    Welcome Data = new Welcome();
    if (resposta.statusCode == 200) {
      Map<String, dynamic> body = json.decode(resposta.body);
      Data = Welcome.fromMap(body);
    }
    if (Data.result!.length > 0) {
      for (var i = 0; i < Data.result!.length; i++) {
        eventosFavLista.add(Data.result![i].event);
      }
    }
    numerofavoritos = eventosFavLista.length;
    orderListEvents(eventosFavLista);
    return eventosFavLista;
  }

  addEventUserData(int id) {
    print('Add Event User Data : $eventosFavoritos');
    if (eventosFavoritos!.contains(id.toString())) {
      print('After add Event User Data : $eventosFavoritos');
      removeEventUserData(id);
      return;
    }
    eventosFavoritos!.add(id.toString());
    saveUserData();
    print('After add Event User Data : $eventosFavoritos');
  }

  removeEventUserData(int id) {
    print('Remove Event User Data : $eventosFavoritos');
    eventosFavoritos!.remove(id.toString());
    saveUserData();
    loadUserData();
    print('After Remove Event User Data : $eventosFavoritos');
  }

  Widget _getIconFavorite(int id) {
    loadUserData();
    String string = id.toString();
    if (eventosFavoritos != null && eventosFavoritos!.contains(string)) {
      return Image.asset(
        'assets/images/icons/icon_favorites.png',
        scale: 2,
      );
    } else {
      return Image.asset(
        'assets/images/icons/icon_favorite.png',
        scale: 1.5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 42, 54),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Favoritos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
              ///////Teste
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  //color: Colors.yellow,
                  height: 645,
                  child: SingleChildScrollView(
                    dragStartBehavior: DragStartBehavior.start,
                    scrollDirection: Axis.vertical,
                    child: Container(
                      //color: Colors.black,
                      height: 650,
                      child: FutureBuilder(
                          future: loadEventFromUserData(),
                          // ignore: missing_return
                          builder:
                              // ignore: missing_return
                              (BuildContext context, AsyncSnapshot snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return Container(
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              case ConnectionState.done:
                                if (numerofavoritos == 0) {
                                  return Container(
                                    child: Center(
                                      child: Text(
                                        'Nao existem eventos favoritos',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  );
                                }
                                return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: numerofavoritos,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var event = snapshot.data[index];
                                      var title = snapshot.data[index].title;
                                      var eventid = snapshot.data[index].id;
                                      var location =
                                          snapshot.data[index].location;
                                      var timeStart = snapshot
                                          .data[index].dates[0].date.timeStart;
                                      var eventdate = snapshot
                                          .data[index].dates[0].date.eventDate;
                                      var image =
                                          'http://${snapshot.data[index].images[0].image.thumbnail}';
                                      List<String?> listcateg = [];
                                      int numcateg = snapshot
                                          .data[index].categories.length;
                                      for (var i = 0; i < numcateg; i++) {
                                        listcateg.add(snapshot.data[index]
                                            .categories[i].category.name);
                                      }
                                      bool imagebool = true;
                                      index == numerofavoritos - 1
                                          ? imagebool = false
                                          : imagebool = true;
                                      return GestureDetector(
                                        onTap: () {
                                          Router_.router.navigateTo(context,
                                              '/eventdetails?eventoid=$eventid');
                                        },
                                        child: EventoContainer(
                                          id: eventid,
                                          title: title,
                                          location: location,
                                          eventdate: eventdate,
                                          timeStart: timeStart,
                                          image: image,
                                          imagebool: imagebool,
                                          categorylist: listcateg,
                                        ),
                                      );
                                    });
                              case ConnectionState.waiting:
                                return Container(
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              case ConnectionState.active:
                                return Container(
                                    child: Center(
                                        child: CircularProgressIndicator()));
                            }
                          }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventoContainer extends StatefulWidget {
  final int? id;
  final String? title;
  final String image;
  final String? location;
  final DateTime? timeStart;
  final DateTime? eventdate;
  final bool imagebool;
  final List<String?> categorylist;
  const EventoContainer({
    Key? key,
    required this.image,
    required this.title,
    required this.location,
    required this.id,
    required this.timeStart,
    required this.eventdate,
    required this.imagebool,
    required this.categorylist,
  }) : super(key: key);
  @override
  _EventoContainerState createState() => _EventoContainerState();
}

class _EventoContainerState extends State<EventoContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventDate(eventdate: widget.eventdate, imagebool: widget.imagebool),
          EventDetailsContainer(
            id: widget.id,
            title: widget.title,
            location: widget.location,
            image: widget.image,
            timeStart: widget.timeStart,
            listaCategorias: widget.categorylist,
          ),
        ],
      ),
    );
  }
}

class EventDate extends StatelessWidget {
  final DateTime? eventdate;
  final bool imagebool;
  const EventDate({
    Key? key,
    required this.eventdate,
    required this.imagebool,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Teste
    var startdate = eventdate!;
    var month = formatDate(startdate, [M]);
    //Fim
    return Container(
      height: 135, //tamanho do container
      width: 50,
      //color: Colors.grey, //verificar espaço do container
      color: Color.fromARGB(255, 34, 42, 54),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            startdate.day.toString(),
            style: TextStyle(
              color: Color.fromRGBO(233, 168, 3, 1),
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            month,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 105,
            width: 10,
            child: imagebool == true
                ? Image(
                    image: AssetImage('assets/images/icons/image_line.png'),
                    fit: BoxFit.fitHeight,
                    height: 105, //tamanho da imagem
                  )
                : null,
          )
        ],
      ),
    );
  }
}

class EventDetailsContainer extends StatefulWidget {
  final int? id;
  final String? title;
  final String image;
  final String? location;
  final DateTime? timeStart;
  final List<String?> listaCategorias;
  const EventDetailsContainer({
    Key? key,
    required this.image,
    required this.title,
    required this.location,
    required this.id,
    required this.timeStart,
    required this.listaCategorias,
  }) : super(key: key);
  @override
  _EventDetailsContainerState createState() => _EventDetailsContainerState();
}

class _EventDetailsContainerState extends State<EventDetailsContainer> {
  late SharedPreferences userpreferences;
  List<String>? eventosFavoritos = [];
  bool _favorite = true;
  var image =
      'http://vivaviseu.projectbox.pt/uploads/event_image/image/9/thumb_descarregar.jpg';

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    userpreferences = await SharedPreferences.getInstance();
    loadUserData();
  }

  addEventUserData(int? id) {
    loadUserData();
    if (eventosFavoritos!.contains(id.toString())) {
      removeEventUserData(id);
      _favorite = false;
      return;
    }
    eventosFavoritos!.add(id.toString());
    _favorite = true;
    saveUserData();
    print('After add Event User Data : $eventosFavoritos');
  }

  removeEventUserData(int? id) {
    loadUserData();
    eventosFavoritos!.remove(id.toString());
    saveUserData();
    print('After Remove Event [$id] User Data : $eventosFavoritos');
  }

  //Load Events id to eventosfavoritos
  loadUserData() async {
    userpreferences = await SharedPreferences.getInstance();
    if (userpreferences.getStringList('favoritos') == null) {
      return;
    }
    eventosFavoritos = userpreferences.getStringList('favoritos');
    print('Load User Data : $eventosFavoritos');
  }

  saveUserData() {
    userpreferences.setStringList('favoritos', eventosFavoritos!);
    loadUserData();
    print('Saved User Data : $eventosFavoritos');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 112,
        width: 311,
        child: Container(
          width: 311,
          child: Row(
            children: [
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  //Widget de Imagem de Evento
                  Container(
                    width: 113,
                    decoration: BoxDecoration(
                      //penso que posso tirar boxdecoration
                      //color: Colors.brown,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.network(
                            widget.image,
                            fit: BoxFit.cover,
                          )),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/images/icons/icon_ellipse.png',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  loadUserData();
                                  addEventUserData(widget.id);
                                });
                              },
                              child: Image(
                                image: _favorite == true
                                    ? AssetImage(
                                        'assets/images/icons/icon_favorites.png')
                                    : AssetImage(
                                        'assets/images/icons/icon_favorite.png'),
                                height: 12,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                  height: 95,
                  width: 198,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 47, 59, 76),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 7),
                        child: Row(
                          children: [
                            CategoryWidget(
                                categorytext: widget.listaCategorias[0]),
                            SizedBox(
                              width: 4,
                            ),
                            widget.listaCategorias.length > 1
                                ? CategoryplusWidget(categorytext: '+1')
                                : Container(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 2, 5, 0),
                        child: Text(
                          widget.title!,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 2, 5, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                                'assets/images/icons/icon_eventdetailswatch.png'),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              formatDate(widget.timeStart!, [HH]) +
                                  'h' +
                                  formatDate(widget.timeStart!, [nn]),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 2, 5, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                                'assets/images/icons/icon_eventdetailslocation.png'),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.location!,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    Key? key,
    required this.categorytext,
  }) : super(key: key);

  final String? categorytext;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      height: 20,
      decoration: BoxDecoration(
          color: Color.fromRGBO(233, 168, 3, 1),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: Text(
          categorytext!,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 11),
        ),
      ),
    );
  }
}

class CategoryplusWidget extends StatelessWidget {
  const CategoryplusWidget({
    Key? key,
    required this.categorytext,
  }) : super(key: key);

  final String categorytext;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 20,
      decoration: BoxDecoration(
          color: Color.fromRGBO(233, 168, 3, 1),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: Text(
          categorytext,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 11),
        ),
      ),
    );
  }
}
