import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivaviseu/calendar.dart';
import 'package:http/http.dart' as http;
import 'package:vivaviseu/highlightedevents.dart';
import 'package:vivaviseu/home.dart';
import 'package:animated_search_bar/animated_search_bar.dart'; //search bar
import 'package:vivaviseu/searching.dart';
import 'package:vivaviseu/utils/category.dart';

import 'config/router.dart';
import 'objects.dart';

int? num;

class AllEvents extends StatefulWidget {
  const AllEvents({
    Key? key,
    this.categoryname
  }) : super(key: key);
  final String? categoryname;
  @override
  _AllEventsState createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  Future<List<Result>?>? allevents; //lista com todos os eventos
  int? numeroeventos; //numero de eventos

  late SharedPreferences userpreferences;
  List<String>? eventosFavoritos = [];

  bool homepage = false;
  bool searching = false;
  String searchtext = '';
  int? numerocategorias = 0;
  bool teste = true;
  @override
  void initState() {
    super.initState();
    allevents = loadallevents();
    numeroeventos = num;
  }

  Future<List<Result>?> loadallevents() async {
    Uri eventosapiUrl =
        Uri.parse("http://vivaviseu.projectbox.pt/api/v1/events");
    print('Link utilizado: $eventosapiUrl');
    var res = await http.get(eventosapiUrl);
    if (res.statusCode == 200) {
      Map<String, dynamic> bodyy = json.decode(res.body);
      Welcome teste = Welcome.fromMap(bodyy);
      print("Numero de Eventos Total: ${teste.result!.length}");
      int i;
      for (i = 0; i < teste.result!.length; i++) {
        print(
            '${teste.result![i].event!.id} , ${teste.result![i].event!.title} , Organizador: ${teste.result![i].event!.organizer!.name}');
      }
      num = teste.getListEvents()!.length;
      return teste.result;
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
    searching = true;
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

  @override
  Widget build(BuildContext context) {
    if (homepage == true) {
      return HighlightedEvents();
    }
    if (searching == true) {
      return SearchWidget();
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 42, 54),
      //backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  //Botão para retornar á HomeScreen()
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Router_.router.pop(context);
                        /*setState(() {
                          homepage = !homepage;
                        });*/
                      }),
                  //Titulo
                  Text(
                    'Todos os Eventos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
              //barra de pesquisa
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Container(
                  height: 50,
                  width: 400,
                  color: Color.fromRGBO(47, 59, 77, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedSearchBar(
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
                          searchtext = value;
                          search(searchtext);
                        });
                      },
                    ),
                  ),
                ),
              ),
              //Scroll de Categorias
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                                            child: CircularProgressIndicator()),
                                      );
                                    case ConnectionState.waiting:
                                      return Container(
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    case ConnectionState.done:
                                      return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: numerocategorias,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var categoryname =
                                                snapshot.data[index].name;
                                            bool? selected;
                                            if(widget.categoryname == categoryname){
                                              selected = true;
                                            }
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Container()//CategoryTab(categoryname: categoryname, preselected: selected,),
                                            );
                                          });
                                    case ConnectionState.active:
                                      return Container(
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                  }
                                }),
                          ),
                        ),
                      ],
                    ),
                  )),
              Container(
                height: 500,
                child: SingleChildScrollView(
                  dragStartBehavior: DragStartBehavior.start,
                  scrollDirection: Axis.vertical,
                  child: Container(
                    //color: Colors.black,
                    height: 500,
                    child: FutureBuilder(
                        future: loadallevents(),
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
                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  //shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: numeroeventos,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var event = snapshot.data[index].event;
                                    var title =
                                        snapshot.data[index].event.title;
                                    var eventid = snapshot.data[index].event.id;
                                    var location =
                                        snapshot.data[index].event.location;
                                    var startdate =
                                        snapshot.data[index].event.startDate;
                                    var formattedDate =
                                        "${startdate.day}-${startdate.month}-${startdate.year}";
                                    var image =
                                        'http://${snapshot.data[index].event.images[0].image.thumbnail}';
                                    return GestureDetector(
                                      onTap: () {
                                        Router_.router.navigateTo(context,
                                            '/eventdetails?eventoid=$eventid');
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: Center(
                                            child: SizedBox(
                                                child: Stack(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    children: [
                                              Container(
                                                color: Color.fromARGB(
                                                    255, 34, 42, 54),
                                                height: 120,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 47, 59, 76),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
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
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                        child: Stack(children: [
                                                          Image.network(
                                                            image,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          Positioned(
                                                            top: 0.1,
                                                            right: 0.1,
                                                            width: 50,
                                                            height: 50,
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          25)),
                                                              child: IconButton(
                                                                icon:
                                                                    Image.asset(
                                                                  'assets/images/icons/icon_favorites.png',
                                                                  scale: 2,
                                                                ),
                                                                onPressed: () {
                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                            ),
                                                          )
                                                        ]),
                                                      ),
                                                    ),
                                                  ]),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('$title'),
                                                        Text('$location'),
                                                        Text(
                                                            '${formattedDate.toString()}')
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ]))),
                                      ),
                                    );
                                  });
                            case ConnectionState.waiting:
                              return Container(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            case ConnectionState.active:
                              return Container(
                                  child: Center(
                                      child: CircularProgressIndicator()));
                          }
                        }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
