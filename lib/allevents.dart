import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vivaviseu/calendar.dart';
import 'package:http/http.dart' as http;

import 'config/router.dart';
import 'objects.dart';

int num;

class AllEvents extends StatefulWidget {
  @override
  _AllEventsState createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  Future<List<Result>> allevents; //lista com todos os eventos
  int numeroeventos; //numero de eventos
  
  @override
  void initState() {
    super.initState();
    allevents = loadallevents();
    numeroeventos = num;
    print(allevents);
    print(numeroeventos);
  }

  Future<List<Result>> loadallevents() async {
    Uri eventosapiUrl =
        Uri.parse("http://vivaviseu.projectbox.pt/api/v1/events");
    print('Link utilizado: $eventosapiUrl');
    var res = await http.get(eventosapiUrl);
    if (res.statusCode == 200) {
      Map<String, dynamic> bodyy = json.decode(res.body);
      Welcome teste = Welcome.fromMap(bodyy);
      print("Numero de Eventos Total: ${teste.result.length}");
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
              //Espaço para barra de pesquisa
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Container(
                  height: 50,
                  width: 400,
                  color: Colors.white,
                ),
              ),
              //Scroll de Categorias
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
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Categoria 1', style: TextStyle(color: Colors.white),),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromRGBO(233, 168, 3, 1.0)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ))),
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
              SingleChildScrollView(
                dragStartBehavior: DragStartBehavior.start,
                scrollDirection: Axis.vertical,
                child: Container(
                  //color: Colors.black,
                  height: 500,
                  child: FutureBuilder(
                  future: loadallevents(),
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
                              itemCount: numeroeventos,
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
                                return GestureDetector(
                                  onTap: (){Router_.router.navigateTo(context, '/eventdetails?eventoid=$eventid');},
                                  child: Padding(
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
                                                    child: Stack(children: [
                                                      Image.network(
                                                        image,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
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
                                                    Text('${formattedDate.toString()}')
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
                            child: Center(child: CircularProgressIndicator()),
                          );
                        case ConnectionState.active:
                          return Container(
                            child: Center(child: CircularProgressIndicator()));
                      }
                    }
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
