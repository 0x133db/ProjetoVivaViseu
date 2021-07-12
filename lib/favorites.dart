import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:connectivity/connectivity.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:vivaviseu/objects.dart';
import 'package:http/http.dart' as http;
import 'package:vivaviseu/utils/containers.dart';
import 'package:vivaviseu/utils/responsive.dart';
import 'package:vivaviseu/utils/style.dart';
import 'package:vivaviseu/utils/utils.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late bool _connectionStatus;
  late ConnectivityResult _connectivityResult = ConnectivityResult.none;

  bool erros = false;

  List<String>? eventosFavoritos = [];
  List<Event?> eventosFavLista = [];
  String url = '';
  int numerofavoritos = 0;

  late UserPreferences up;

  @override
  void initState() {
    print('[---------- Página Favoritos ----------]');
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
          setState(() {
            erros = false;
            _connectionStatus = true;
          });
          print(_connectionStatus);
        });
        break;
      case ConnectivityResult.mobile:
        if (!mounted) {
          break;
        }
        setState(() {
          setState(() {
            erros = false;
            _connectionStatus = true;
          });
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
    _connectionStatus = true;
    try {
      _connectivityResult = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      _connectionStatus = false;
      return;
    }
    _connectionStatus = true;
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(_connectivityResult);
  }

  //get events from user favorites and gets them from api
  Future<List<Event?>?> loadFavorites() async {
    print('Loading Users Favorites Events ...');
    up = await UserPreferences();
    eventosFavoritos!.clear();
    eventosFavLista.clear();
    eventosFavoritos = up.getFavoritos();
    String url = 'http://vivaviseu.projectbox.pt/api/v1/events?event_list=';
    for (var i = 0; i < eventosFavoritos!.length; i++) {
      String getid = eventosFavoritos![i];
      url = url + '$getid,';
      print('$url');
    }
    numerofavoritos = eventosFavoritos!.length;
    if (url == 'http://vivaviseu.projectbox.pt/api/v1/events?event_list=') {
      return eventosFavLista;
    }
    if (_connectivityResult != ConnectivityResult.none) {
      Uri eventosfavoritosurl = Uri.parse(url);
      print('Conexão $_connectionStatus');
      print('Link utilizado para Eventos Favoritos: $eventosfavoritosurl');
      var resposta;
      try {
        resposta = await http.get(eventosfavoritosurl);
      } on SocketException catch (e) {
        print(e.toString());
        erros = true;
        return eventosFavLista;
      } on http.ClientException catch (e) {
        print(e.toString());
        erros = true;
        return eventosFavLista;
      } on PlatformException catch (e) {
        print(e.toString());
        erros = true;
        return eventosFavLista;
      } on Exception catch (e) {
        print(e.toString());
        erros = true;
        return eventosFavLista;
      } catch (e) {
        erros = true;
        return eventosFavLista;
      }
      Welcome Data = new Welcome();
      try {
        if (resposta.statusCode == 200) {
          Map<String, dynamic> body = json.decode(resposta.body);
          Data = Welcome.fromMap(body);
        }
        if (Data.result != null) {
          if (Data.result!.length > 0) {
            for (var i = 0; i < Data.result!.length; i++) {
              eventosFavLista.add(Data.result![i].event);
            }
          }
        }
        orderListEvents(eventosFavLista);
        return eventosFavLista;
      } on Exception catch (e) {
        print(e.toString());
        return eventosFavLista;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 34, 42, 54),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                6 * SizeConfig.widthMultiplier!,
                2.5 * SizeConfig.heightMultiplier!,
                6 * SizeConfig.widthMultiplier!,
                0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Favoritos',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  _connectionStatus == true && erros == false
                      ? Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.heightMultiplier! * 3),
                            child: FutureBuilder(
                                future: loadFavorites(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      return Container(
                                        child: Center(
                                            child: Text('Connection none')),
                                      );
                                    case ConnectionState.done:
                                      if (eventosFavLista.length == 0) {
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
                                      return Container(
                                        height: SizeConfig.maxHeight,
                                        width: SizeConfig.maxWidth,
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            physics: ClampingScrollPhysics(),
                                            itemCount: eventosFavLista.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var event = snapshot.data[index];
                                              var title =
                                                  snapshot.data[index].title;
                                              var eventid =
                                                  snapshot.data[index].id;
                                              var location =
                                                  snapshot.data[index].location;
                                              var timeStart = snapshot
                                                  .data[index]
                                                  .dates[0]
                                                  .date
                                                  .timeStart;
                                              var eventdate = snapshot
                                                  .data[index]
                                                  .dates[0]
                                                  .date
                                                  .eventDate;
                                              var image =
                                                  'http://${snapshot.data[index].images[0].image.thumbnail}';
                                              List<String?> listcateg = [];
                                              int numcateg = snapshot
                                                  .data[index]
                                                  .categories
                                                  .length;
                                              for (var i = 0;
                                                  i < numcateg;
                                                  i++) {
                                                listcateg.add(snapshot
                                                    .data[index]
                                                    .categories[i]
                                                    .category
                                                    .name);
                                              }
                                              bool imagebool = true;
                                              index == numerofavoritos - 1
                                                  ? imagebool = false
                                                  : imagebool = true;
                                              return GestureDetector(
                                                onTap: () {
                                                  Router_.router.navigateTo(
                                                      context,
                                                      '/eventdetails?eventoid=$eventid');
                                                },
                                                child: WidgetContainerEventos(
                                                  evento: event,
                                                  userPreferences: up,
                                                  listacategorias: listcateg,
                                                  imagebool: imagebool,
                                                ),
                                              );
                                            }),
                                      );
                                    case ConnectionState.waiting:
                                      return Container(
                                        child: Center(
                                            child: Theme(
                                          data: Theme.of(context).copyWith(
                                            accentColor:
                                                Color.fromRGBO(233, 168, 3, 1),
                                          ),
                                          child: CircularProgressIndicator(),
                                        )),
                                      );
                                    case ConnectionState.active:
                                      return Container(
                                          child: Center(
                                              child: Theme(
                                        data: Theme.of(context).copyWith(
                                          accentColor:
                                              Color.fromRGBO(233, 168, 3, 1),
                                        ),
                                        child: CircularProgressIndicator(),
                                      )));
                                  }
                                }),
                          ),
                        )
                      : erros == true
                          ? Expanded(child: ContainerGeneralError())
                          : Expanded(child: ContainerNetworkError())
                ],
              ),
            ),
          ),
        ));
  }
}

class EventoContainer extends StatefulWidget {
  final UserPreferences userPreferences;
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
    required this.userPreferences,
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
      //color: Colors.green,
      height: 15 * SizeConfig.heightMultiplier!,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 1),
              child: EventDate(
                  eventdate: widget.eventdate, imagebool: widget.imagebool),
            ),
          ),
          Flexible(
            flex: 4,
            child: EventDetailsContainer(
              userPreferences: widget.userPreferences,
              id: widget.id,
              title: widget.title,
              location: widget.location,
              image: widget.image,
              timeStart: widget.timeStart,
              listaCategorias: widget.categorylist,
            ),
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
      height: 15 * SizeConfig.heightMultiplier!, //altura do container data
      width: SizeConfig.maxWidth! * 0.15, //largura container data
      //color: Colors.grey, //verificar espaço do container
      color: Color.fromARGB(255, 34, 42, 54),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            startdate.day.toString(),
            style: TextStyle(
              color: Color.fromRGBO(233, 168, 3, 1),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            month,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Container(
            child: imagebool == true
                ? Expanded(
                    child: Image(
                      image: AssetImage('assets/images/icons/image_line.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  )
                : null,
          )
        ],
      ),
    );
  }
}

class EventDetailsContainer extends StatefulWidget {
  final UserPreferences userPreferences;
  final int? id;
  final String? title;
  final String image;
  final String? location;
  final DateTime? timeStart;
  final List<String?> listaCategorias;
  const EventDetailsContainer({
    Key? key,
    required this.userPreferences,
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
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            //Widget de Imagem de Evento
            Container(
              height: 1 * SizeConfig.heightMultiplier!,
              width: 1 * SizeConfig.widthMultiplier!,
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
                  top: 6,
                  right: 10,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image(
                        image: AssetImage(
                          'assets/images/icons/icon_ellipse.png',
                        ),
                        height: 3 * SizeConfig.heightMultiplier!,
                        color: Colors.transparent,
                        colorBlendMode: BlendMode.hardLight,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.userPreferences.isFavorito(widget.id!)) {
                              widget.userPreferences.removeFavorito(widget.id!);
                            } else {
                              widget.userPreferences.addFavorito(widget.id!);
                            }
                          });
                        },
                        child: Image(
                            image: widget.userPreferences.isFavorito(widget.id!)
                                ? AssetImage(
                                    'assets/images/icons/icon_favorites.png',
                                  )
                                : AssetImage(
                                    'assets/images/icons/icon_favorite.png'),
                            height: 3 * SizeConfig.heightMultiplier!),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        Expanded(
          child: Container(
              height: 11 * SizeConfig.heightMultiplier!,
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
                        Flexible(
                          //fit: FlexFit.loose,
                          child: CategoryWidget(context,
                              categorytext: widget.listaCategorias[0]),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        widget.listaCategorias.length > 1
                            ? CategoryplusWidget(context, categorytext: '+1')
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
                            'assets/images/icons/icon_eventdetailswatch.png',
                            scale: 2),
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
                          'assets/images/icons/icon_eventdetailslocation.png',
                          scale: 2,
                        ),
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
              )),
        )
      ],
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(
    BuildContext context, {
    Key? key,
    required this.categorytext,
  }) : super(key: key);

  final String? categorytext;

  @override
  Widget build(BuildContext context) {
    return Container(
        //width: SizeConfig.widthMultiplier! * 18,
        //width: SizeConfig.widthMultiplier! * 18,
        height: SizeConfig.heightMultiplier! * 2.3,
        decoration: BoxDecoration(
            color: Color.fromRGBO(233, 168, 3, 1),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.widthMultiplier! * 3,
              right: SizeConfig.widthMultiplier! * 3),
          child: Center(
            child: Text(
              categorytext!,
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(fontSize: 1.3 * SizeConfig.textMultiplier!),
            ),
          ),
        ));
  }
}

class CategoryplusWidget extends StatelessWidget {
  const CategoryplusWidget(
    BuildContext context, {
    Key? key,
    required this.categorytext,
  }) : super(key: key);

  final String categorytext;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.widthMultiplier! * 5.7,
      height: SizeConfig.heightMultiplier! * 2.3,
      decoration: BoxDecoration(
          color: Color.fromRGBO(233, 168, 3, 1),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: Text(categorytext,
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(fontSize: 1.3 * SizeConfig.textMultiplier!)),
      ),
    );
  }
}

class WidgetContainerEventos extends StatefulWidget {
  const WidgetContainerEventos(
      {Key? key,
      required this.evento,
      required this.userPreferences,
      required this.listacategorias,
      required this.imagebool})
      : super(key: key);
  final Event evento;
  final UserPreferences userPreferences;
  final List<String?> listacategorias;
  final bool imagebool;

  @override
  _WidgetContainerEventosState createState() => _WidgetContainerEventosState();
}

class _WidgetContainerEventosState extends State<WidgetContainerEventos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier! *
          20, //altura do container total (influencia todos os containers filhos)
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              height: SizeConfig.heightMultiplier! * 20,
              child: WidgetContainerImagemData(
                imagebool: widget.imagebool,
                evento: widget.evento,
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: SizeConfig.heightMultiplier! *
                    16, //altura container com imagem e informaçoes
                child: WidgetImagemDetalhesEventos(
                    evento: widget.evento,
                    userPreferences: widget.userPreferences,
                    listacategorias: widget.listacategorias),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetImagemDetalhesEventos extends StatefulWidget {
  const WidgetImagemDetalhesEventos(
      {Key? key,
      required this.evento,
      required this.userPreferences,
      required this.listacategorias})
      : super(key: key);
  final Event evento;
  final UserPreferences userPreferences;
  final List<String?> listacategorias;

  @override
  _WidgetImagemDetalhesEventosState createState() =>
      _WidgetImagemDetalhesEventosState();
}

class _WidgetImagemDetalhesEventosState
    extends State<WidgetImagemDetalhesEventos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            height: SizeConfig.heightMultiplier! * 16,
            width: SizeConfig.widthMultiplier! * 29,
            child: Stack(fit: StackFit.expand, children: [
              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    'http://${widget.evento.images![0].image!.thumbnail!}',
                    fit: BoxFit.cover,
                  )),
              Positioned(
                top: 6,
                right: 10,
                child: Center(
                  child: Stack(alignment: Alignment.center, children: [
                    Image(
                      image: AssetImage(
                        'assets/images/icons/icon_ellipse.png',
                      ),
                      height: 3 * SizeConfig.heightMultiplier!,
                      color: Colors.transparent,
                      colorBlendMode: BlendMode.hardLight,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.userPreferences
                              .isFavorito(widget.evento.id!)) {
                            widget.userPreferences
                                .removeFavorito(widget.evento.id!);
                          } else {
                            widget.userPreferences
                                .addFavorito(widget.evento.id!);
                          }
                        });
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Image(
                            image: widget.userPreferences
                                    .isFavorito(widget.evento.id!)
                                ? AssetImage(
                                    'assets/images/icons/icon_favorites.png',
                                  )
                                : AssetImage(
                                    'assets/images/icons/icon_favorite.png'),
                            height: 2.6 * SizeConfig.heightMultiplier!),
                      ),
                    )
                  ]),
                ),
              ),
            ]),
          ),
          Expanded(
            flex: 4,
            child: Container(
              height: SizeConfig.heightMultiplier! * 13.5,
              decoration: BoxDecoration(
                color: AppTheme.appEventContainerColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    SizeConfig.widthMultiplier! * 2.1,
                    SizeConfig.heightMultiplier! * 1.2,
                    SizeConfig.widthMultiplier! * 2.1,
                    SizeConfig.heightMultiplier! * 1.2),
                child: Container(
                  //color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          //color: Colors.white,
                          child: Row(
                            children: [
                              CategoryWidget(context,
                                  categorytext: widget.listacategorias[0]),
                              SizedBox(
                                width: SizeConfig.widthMultiplier! * 1.5,
                              ),
                              widget.listacategorias.length > 1
                                  ? CategoryplusWidget(context,
                                      categorytext:
                                          '+${widget.listacategorias.length - 1}')
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              0,
                              SizeConfig.heightMultiplier! * 0.7,
                              0,
                              SizeConfig.heightMultiplier! * 0.7),
                          child: Text(
                            widget.evento.title!,
                            style: Theme.of(context).textTheme.headline2!,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/icons/icon_eventdetailswatch.png',
                                  height: SizeConfig.imageSizeMultiplier! * 2.5,
                                ),
                                SizedBox(
                                  width: SizeConfig.widthMultiplier! * 1.5,
                                ),
                                Text(
                                    '${formatDate(widget.evento.dates![0].date!.timeStart!, [
                                          HH
                                        ])}' +
                                        'h' +
                                        '${formatDate(widget.evento.dates![0].date!.timeStart!, [
                                          nn
                                        ])}',
                                    style: Theme.of(context).textTheme.caption),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.heightMultiplier! * 0.3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Image.asset(
                                    'assets/images/icons/icon_eventdetailslocation.png',
                                    height:
                                        SizeConfig.imageSizeMultiplier! * 2.5,
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.widthMultiplier! * 1.5,
                                ),
                                Flexible(
                                  flex: 9,
                                  child: Text(
                                    widget.evento.location!,
                                    style: Theme.of(context).textTheme.caption,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WidgetContainerImagemData extends StatelessWidget {
  const WidgetContainerImagemData(
      {Key? key, required this.evento, required this.imagebool})
      : super(key: key);
  final Event evento;
  final bool imagebool;
  @override
  Widget build(BuildContext context) {
    DateTime startdate = evento.dates![0].date!.eventDate!;
    var mes = formatDate(startdate, [M], locale: PortugueseDateLocale());
    return Container(
      height: SizeConfig.heightMultiplier! * 19,
      width: SizeConfig.maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            startdate.day.toString(),
            style: TextStyle(
              color: Color.fromRGBO(233, 168, 3, 1),
              fontWeight: FontWeight.bold,
              fontSize: 1.6 * SizeConfig.textMultiplier!,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            mes,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 1.7 * SizeConfig.textMultiplier!),
          ),
          Container(
            child: imagebool == true
                ? Expanded(
                    child: Image(
                      image: AssetImage('assets/images/icons/image_line.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  )
                : null,
          )
        ],
      ),
    );
  }
}
