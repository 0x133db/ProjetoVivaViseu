import 'dart:convert';

import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vivaviseu/allevents.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:vivaviseu/home.dart';
import 'package:http/http.dart' as http;

import 'objects.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool searching = true;
  bool homepage = false;
  String searchtext = '';
  int numeropesquisa = 0;

  //Funçao de pesquisa de eventos
  Future<List<Result>?> search(String content) async {
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
      numeropesquisa = Data.result!.length;
      return Data.result;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (homepage = true) {
      HighlightedEvents();
    }
    if (searching == false) {
      return AllEvents();
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
                        setState(() {
                          searching = !searching;
                          homepage = !homepage;
                        });
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
                          if (value == '') {
                            searching = !searching;
                          }
                          searchtext = value;
                          searching = true;
                          search(searchtext);
                        });
                      },
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                dragStartBehavior: DragStartBehavior.start,
                scrollDirection: Axis.vertical,
                child: Container(
                  //color: Colors.black,
                  height: 490,
                  child: FutureBuilder(
                      future: search(searchtext),
                      // ignore: missing_return
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Container(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          case ConnectionState.done:
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                //shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: numeropesquisa,
                                itemBuilder: (BuildContext context, int index) {
                                  var title = snapshot.data[index].event.title;
                                  var eventid = snapshot.data[index].event.id;
                                  var location =
                                      snapshot.data[index].event.location;
                                  var startdate =
                                      snapshot.data[index].event.startDate;
                                  var formattedDate =
                                      "${startdate.day}-${startdate.month}-${startdate.year}";
                                  var image =
                                      'http://${snapshot.data[index].event.images[0].image.thumbnail}';
                                  if(numeropesquisa == 0){
                                    return Container(
                                      child: Center(
                                        child: Text('Não Existem Eventos!'),
                                      ),
                                    );
                                  }else{
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
                                                      child: Stack(children: [
                                                        Image.network(
                                                          image,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          25)),
                                                          child: Image.asset(
                                                            'assets/images/icons/icon_favorites.png',
                                                            alignment: Alignment
                                                                .topRight,
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
                                                        MainAxisAlignment.start,
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
                                  );}
                                });
                          case ConnectionState.waiting:
                            return Container(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          case ConnectionState.active:
                            return Container(
                                child:
                                    Center(child: CircularProgressIndicator()));
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
