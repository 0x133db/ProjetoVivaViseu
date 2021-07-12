import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:vivaviseu/objects.dart';
import 'package:vivaviseu/utils/category.dart';
import 'package:vivaviseu/utils/containers.dart';
import 'package:vivaviseu/utils/responsive.dart';
import 'package:vivaviseu/utils/style.dart';
import 'package:vivaviseu/utils/utils.dart';
import 'package:connectivity/connectivity.dart';

//card swiper
import 'package:flutter_card_swipper/flutter_card_swiper.dart';

import 'favorites.dart';
//

class HighlightedEvents extends StatefulWidget {
  HighlightedEvents({Key? key}) : super(key: key);

  @override
  HighlightedEventsState createState() => HighlightedEventsState();
}

class HighlightedEventsState extends State<HighlightedEvents> {
  List<Result>? eventosemdestaque = []; //lista de eventos em destaque
  List<CategoryCategory> listaCategorias = [];
  late int numeroeventos; //numero de eventos em destaque
  int? numerocategorias; //numero de categorias

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _connectionStatus = true;
  late ConnectivityResult _connectivityResult = ConnectivityResult.none;

  bool erros = false;

  late UserPreferences userPref;

  String searchtext = '';

  @override
  void initState() {
    print('[---------- Página Eventos em Destaque ----------]');
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        if (!mounted) {
          break;
        }
        setState(() {
          erros = false;
          _connectionStatus = true;
          print(_connectionStatus);
        });
        break;
      case ConnectivityResult.mobile:
        if (!mounted) {
          break;
        }
        setState(() {
          erros = false;
          _connectionStatus = true;
          print(_connectionStatus);
        });
        break;
      case ConnectivityResult.none:
        if (!mounted) {
          break;
        }
        setState(() {
          erros = false;
          _connectionStatus = false;
        });
        print(_connectionStatus);
        break;
      default:
        if (!mounted) {
          break;
        }
        ;
        setState(() {
          erros = false;
          _connectionStatus = false;
        });
        print(_connectionStatus);
        break;
    }
  }

  Future<void> initConnectivity() async {
    try {
      _connectivityResult = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(_connectivityResult);
  }

  Future<List<Result>?> loadData() async {
    userPref = await UserPreferences();
    //eventosemdestaque = [];
    Uri eventosapiUrl =
        Uri.parse("http://vivaviseu.projectbox.pt/api/v1/highlighted_events");
    print('Link utilizado para Eventos em Destaque: $eventosapiUrl');
    if (_connectivityResult != ConnectivityResult.none) {
      eventosemdestaque = [];
      numeroeventos = 0;
      print('Conexão $_connectionStatus');
      var resposta;
      try {
        resposta = await http.get(eventosapiUrl);
      } on SocketException catch (e) {
        print(e.toString());
        erros = true;
        throw Exception;
      } on http.ClientException catch (e) {
        print(e.toString());
        erros = true;
        throw Exception;
      } on PlatformException catch (e) {
        print(e.toString());
        erros = true;
        throw Exception;
      } on Exception catch (e) {
        print(e.toString());
        erros = true;
        throw Exception;
      } catch (e) {
        erros = true;
        throw Exception;
      }
      try {
        if (resposta.statusCode == 200) {
          Map<String, dynamic> body = json.decode(resposta.body);
          Welcome Data = Welcome.fromMap(body);
          print("Número de Eventos em Destaque: ${Data.result!.length}");
          int i;
          if (Data.result!.length == 0) {
            eventosemdestaque = [];
          } else {
            for (i = 0; i < Data.result!.length; i++) {
              print(
                  'Evento: [ID:${Data.result![i].event!.id}] , Título: ${Data.result![i].event!.title} , Organizador: ${Data.result![i].event!.organizer!.name}');
            }
            numeroeventos = Data.getListEvents()!.length;
            eventosemdestaque = Data.result;
            return eventosemdestaque;
          }
        } else {
          erros = true;
          return eventosemdestaque;
        }
      } on Exception catch (e) {
        print(e.toString());
        erros = true;
        return eventosemdestaque;
      }
    }
  }

  Future<List<CategoryCategory>?> loadCategories() async {
    Uri categoriesapiUrl =
        Uri.parse("http://vivaviseu.projectbox.pt/api/v1/categories");
    numeroeventos = 0;
    listaCategorias.clear();
    print('Link utilizado para Categorias: $categoriesapiUrl');
    if (_connectivityResult != ConnectivityResult.none) {
      print('Conexão $_connectionStatus');
      var resposta;
      try {
        resposta = await http.get(categoriesapiUrl);
      } on SocketException catch (e) {
        print(e.toString());
        erros = true;
        throw SocketException;
      } on http.ClientException catch (e) {
        print(e.toString());
        erros = true;
        throw http.ClientException;
      } on PlatformException catch (e) {
        print(e.toString());
        erros = true;
        throw PlatformException;
      } on Exception catch (e) {
        print(e.toString());
        erros = true;
        throw Exception;
      } catch (e) {
        erros = true;
        throw Exception;
      }
      try {
        if (resposta.statusCode == 200) {
          Map<String, dynamic> body = json.decode(resposta.body);
          numerocategorias = body['result'].length;
          for (int i = 0; i < body['result'].length; i++) {
            CategoryCategory category =
                CategoryCategory.fromMap(body['result'][i]['category']);
            print('${category.name}');
            listaCategorias.add(category);
          }
          return listaCategorias;
        }
      } on Exception catch (e) {
        print(e.toString());
        return listaCategorias;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 34, 42, 54),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    6 * SizeConfig.widthMultiplier!,
                    2 * SizeConfig.heightMultiplier!,
                    6 * SizeConfig.widthMultiplier!,
                    0),
                child: OutlineSearchBar(
                  hintText: 'Pesquisar',
                  searchButtonIconColor: Color.fromRGBO(153, 176, 210, 1),
                  searchButtonPosition: SearchButtonPosition.leading,
                  backgroundColor: Color.fromRGBO(47, 59, 77, 1),
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  clearButtonColor: Colors.transparent,
                  textInputAction: TextInputAction.search,
                  maxLength: 25,
                  textStyle: AppTheme.TextStyleTheme.headline4!,
                  hintStyle: AppTheme.TextStyleTheme.headline4!
                      .copyWith(color: Color.fromRGBO(152, 176, 210, 1)),
                  cursorColor: Color.fromRGBO(233, 168, 3, 1),
                  onSearchButtonPressed: (value) {
                    print('Vou mandar isto $value');
                    Router_.router.navigateTo(
                        context, '/listagemgeralpesquisa?text=$value');
                  },
                ),
              ),
              //Barra de Categorias
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      6 * SizeConfig.widthMultiplier!,
                      2.2 * SizeConfig.heightMultiplier!,
                      6 * SizeConfig.widthMultiplier!,
                      0),
                  child: _connectionStatus != false
                      ? SingleChildScrollView(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 4 * SizeConfig.heightMultiplier!,
                                  child: FutureBuilder(
                                      future: loadCategories(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.data == null) {
                                          return Container(
                                            height: 4 *
                                                SizeConfig.heightMultiplier!,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: 3,
                                                itemBuilder:
                                                    (BuildContext contex,
                                                        int index) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        right: SizeConfig
                                                            .heightMultiplier!),
                                                    child:
                                                        CategoryTabSimpleNoNetwork(),
                                                  );
                                                }),
                                          );
                                        }
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
                                                      CircularProgressIndicator(
                                                      )),
                                            );
                                          case ConnectionState.done:
                                            if (numerocategorias == 0) {
                                              return Container(
                                                height: 4 *
                                                    SizeConfig
                                                        .heightMultiplier!,
                                                child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: 3,
                                                    itemBuilder:
                                                        (BuildContext contex,
                                                            int index) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                            right: SizeConfig
                                                                .heightMultiplier!),
                                                        child:
                                                            CategoryTabSimpleNoNetwork(),
                                                      );
                                                    }),
                                              );
                                            } else {
                                              return ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: numerocategorias,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    var categoryname = snapshot
                                                        .data[index].name;
                                                    var categoryid =
                                                        snapshot.data[index].id;
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          right: SizeConfig
                                                              .heightMultiplier!),
                                                      child: CategoryTabSimple(
                                                        categoryname:
                                                            categoryname,
                                                        id: categoryid,
                                                      ),
                                                    );
                                                  });
                                            }
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
                        )
                      : Container(
                          height: 4 * SizeConfig.heightMultiplier!,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (BuildContext contex, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      right: SizeConfig.heightMultiplier!),
                                  child: CategoryTabSimpleNoNetwork(),
                                );
                              }),
                        )),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    6 * SizeConfig.widthMultiplier!,
                    2.5 * SizeConfig.heightMultiplier!,
                    6 * SizeConfig.widthMultiplier!,
                    0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Destaques',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    GestureDetector(
                      onTap: () {
                        Router_.router.navigateTo(context, '/listagemgeral');
                      },
                      child: Text(
                        'ver todos',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ],
                ),
              ),
              _connectionStatus != false && erros == false
                  ? Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier! * 3.3),
                        child: Container(
                          //height: 54 * SizeConfig.heightMultiplier!,
                          //color: Colors.yellow,
                          height: SizeConfig.maxHeight! * 0.65,
                          width: SizeConfig.maxWidth,
                          child: FutureBuilder(
                              future: loadData(),
                              // ignore: missing_return
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
                                  case ConnectionState.done:
                                    if (erros == true) {
                                      return ContainerGeneralError();
                                    }
                                    if (eventosemdestaque == null) {
                                      return ContainerNoHighlights();
                                    }
                                    if (snapshot.hasData == false) {
                                      return ContainerNoHighlights();
                                    }
                                    return Swiper(
                                        itemCount: numeroeventos,
                                        itemWidth: SizeConfig.maxWidth! * 0.7,
                                        itemHeight:
                                            SizeConfig.maxHeight! * 0.55,
                                        scrollDirection: Axis.horizontal,
                                        layout: SwiperLayout.STACK,
                                        itemBuilder:
                                            (BuildContext Context, int index) {
                                          var event =
                                              snapshot.data[index].event;
                                          var eventid =
                                              snapshot.data[index].event.id;                                       
                                          List<String?> listcateg = [];
                                          int numcateg =
                                              event.categories.length;
                                          for (var i = 0; i < numcateg; i++) {
                                            listcateg.add(event
                                                .categories[i].category.name);
                                          }
                                          return GestureDetector(
                                              onTap: () {
                                                Router_.router.navigateTo(
                                                    context,
                                                    '/eventdetails?eventoid=$eventid');
                                              },
                                              child: EventCard(
                                                  evento: event, up: userPref));
                                        });
                                  case ConnectionState.waiting:
                                    return Container(
                                      height: 400,
                                      child: Center(
                                          child: CircularProgressIndicator()),
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
                      ),
                    )
                  : _connectionStatus == false
                      ? Expanded(child: ContainerNetworkError())
                      : Expanded(child: ContainerGeneralError())
            ]),
          ),
        ));
  }
}

class EventCard extends StatefulWidget {
  const EventCard({Key? key, required this.evento, required this.up})
      : super(key: key);
  final Event evento;
  final UserPreferences up;

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  var eventid;
  var title;
  var location;
  var startdate;
  String formattedDate = '';
  String timeevent = '';
  var image;
  late int numcateg;
  List<String?> listcateg = [];
  late bool errornetworkimage;

  
  void initState() {
    eventid = widget.evento.id;
    title = widget.evento.title;
    location = widget.evento.location;
    startdate = widget.evento.startDate;
    formattedDate = formatDate(widget.evento.dates![0].date!.eventDate!, [dd]) +
        ' de ' +
        formatDate(widget.evento.dates![0].date!.eventDate!, [MM],
            locale: PortugueseDateLocale()) +
        ' ' +
        formatDate(widget.evento.dates![0].date!.eventDate!, [yyyy]);
    timeevent =
        '${formatDate(widget.evento.dates![0].date!.timeStart!, [HH])}' +
            'h' +
            '${formatDate(widget.evento.dates![0].date!.timeStart!, [nn])}';
    image = 'http://${widget.evento.images![0].image!.original}';
    numcateg = widget.evento.categories!.length;
    for (var i = 0; i < numcateg; i++) {
      listcateg.add(widget.evento.categories![i].category!.name);
    }
    errornetworkimage = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.grey[900],
        elevation: 5,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Stack(
          children: [
            ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                      begin: Alignment(0, -0.1),
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 34, 42, 54),
                        Colors.transparent
                      ]).createShader(
                      Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: /*errornetworkimage != false ? */ DecorationImage(
                      image: NetworkImage(
                        image,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                )),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(
                    right: 2 * SizeConfig.widthMultiplier!,
                    top: 2 * SizeConfig.widthMultiplier!),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (widget.up.isFavorito(widget.evento.id!)) {
                        widget.up.removeFavorito(widget.evento.id!);
                      } else {
                        widget.up.addFavorito(widget.evento.id!);
                      }
                    });
                  },
                  child: Container(
                    //color: Colors.yellow,
                    height: 3 * SizeConfig.heightMultiplier!,
                    width: 3 * SizeConfig.heightMultiplier!,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Image.asset(
                            'assets/images/icons/icon_ellipse.png',
                            scale: 2.5,
                            color: Colors.white,
                            width: 10 * SizeConfig.imageSizeMultiplier!,
                          ),
                        ),
                        Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: widget.up.isFavorito(widget.evento.id!)
                                ? Image.asset(
                                    'assets/images/icons/icon_favorites.png',
                                    height: SizeConfig.heightMultiplier! *1.5,
                                  )
                                : Image.asset(
                                    'assets/images/icons/icon_favorite.png',
                                    height: SizeConfig.heightMultiplier! *1.5,))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.heightMultiplier! * 2,
                    bottom: SizeConfig.heightMultiplier! * 1.5),
                child: Container(
                  height: SizeConfig.heightMultiplier! * 10,
                  //color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Desenho de Categoria
                      Expanded(
                        child: Padding(
                          //padding: const EdgeInsets.fromLTRB(10, 10, 10, 7),
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            children: [
                              CategoryWidget(context,
                                  categorytext: listcateg[0]),
                              SizedBox(
                                width: SizeConfig.widthMultiplier! * 1.5,
                              ),
                              listcateg.length > 1
                                  ? CategoryplusWidget(context,
                                      categorytext: '+1')
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontSize: 1.5 * SizeConfig.textMultiplier!,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: SizeConfig.widthMultiplier!),
                              child: Container(
                                width: SizeConfig.heightMultiplier! * 1.2,
                                height: SizeConfig.heightMultiplier! * 1.2,
                                child: Image.asset(
                                  'assets/images/icons/icon_eventdetailscalendar.png',
                                  height: SizeConfig.heightMultiplier! * 1.2,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: SizeConfig.widthMultiplier! * 2.5),
                              child: Container(
                                child: Text(
                                  formattedDate,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: SizeConfig.widthMultiplier!),
                              child: Container(
                                color: Colors.black,
                                width: SizeConfig.heightMultiplier! * 1.2,
                                height: SizeConfig.heightMultiplier! * 1.2,
                                child: Image.asset(
                                  'assets/images/icons/icon_eventdetailswatch.png',
                                  height: SizeConfig.heightMultiplier! * 1.2,
                                ),
                              ),
                            ),
                            Text(
                              timeevent,
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        /*mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,*/
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: SizeConfig.widthMultiplier!),
                            child: Container(
                              width: SizeConfig.heightMultiplier! * 1.2,
                              height: SizeConfig.heightMultiplier! * 1.2,
                              child: Image.asset(
                                'assets/images/icons/icon_eventdetailslocation.png',
                                alignment: Alignment.center,
                                height: SizeConfig.heightMultiplier! * 1.2,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              location,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
