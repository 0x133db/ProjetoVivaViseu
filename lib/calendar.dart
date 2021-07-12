import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:vivaviseu/favorites.dart';
import 'package:vivaviseu/objects.dart';
import 'package:http/http.dart' as http;
import 'package:date_format/date_format.dart';
import 'package:vivaviseu/calendareventslist.dart';
import 'package:vivaviseu/utils/containers.dart';
import 'package:vivaviseu/utils/responsive.dart';
import 'package:vivaviseu/utils/utils.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  LinkedHashMap<DateTime, List<Event>> mapaeventos =
      LinkedHashMap<DateTime, List<Event>>();
  int? numeroeventos;
  List<String> eventidsStrings = [];
  final ValueNotifier<bool> eventschange = ValueNotifier(false);
  late UserPreferences teste;

  @override
  void initState() {
    print('[---------- Página de Calendário de Eventos ----------]');
    //super.initState();
    teste = UserPreferences();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void>? loadeventsmap() async {
    mapaeventos.clear();
    Uri eventosapiUrl =
        Uri.parse("http://vivaviseu.projectbox.pt/api/v1/events");
    print('Link utilizado para Construir Mapa de Eventos: $eventosapiUrl');
    var res;
    try {
      res = await http.get(eventosapiUrl);
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    } on Exception catch (e) {
      print(e.toString());
      return;
    }
    try {
      if (res.statusCode == 200) {
        Map<String, dynamic> body = json.decode(res.body);
        Welcome Data = Welcome.fromMap(body);
        if (Data.result != null) {
          print("Numero de Eventos Total: ${Data.result!.length}");
          int i;
          for (i = 0; i < Data.result!.length; i++) {
            if (Data.result![i].event!.hasRecurringDates == true) {
              for (int x = 0; x < Data.result![i].event!.dates!.length; x++) {
                var date = Data.result![i].event!.dates![x].date!.eventDate;
                Event event = Data.result![i].event!;
                if (mapaeventos[date!] == null) {
                  mapaeventos[date] = [];
                }
                if (mapaeventos[date]!.contains(event.id)) {
                  return;
                } else {
                  mapaeventos[date]!.add(event);
                }
              }
            } else {
              var startdate = Data.result![i].event!.startDate;
              var enddate = Data.result![i].event!.endDate;
              var daysdif = enddate!.difference(startdate!).inDays;
              var date = startdate;
              print('dias diferença : $daysdif');
              for (int x = 0; x <= daysdif; x++) {
                Event event = Data.result![i].event!;
                if (mapaeventos[date] == null) {
                  mapaeventos[date] = [];
                }
                if (mapaeventos[date]!.contains(event.id)) {
                  return;
                } else {
                  mapaeventos[date]!.add(event);
                }
                date = date.add(Duration(days: 1));
              }
            }
          }
          print('$mapaeventos');
          return;
        }
      }
    } on Exception catch (e) {
      print(e.toString());
      return;
    }
  }

  List<String>? listaEvent;
  void buildListEvent(List<Event>? Eventos) {
    if (Eventos == null) {
      return;
    } else {
      listaEvent = [];
    }
    for (var i = 0; i < Eventos.length; i++) {
      String id = "${Eventos[i].id}";
      listaEvent!.add(id);
    }
  }

  void checkTodays() {
    DateTime hoje =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (mapaeventos[hoje] != null) {
      eventschange.value = true;
      print('Hoje há Eventos : ${mapaeventos[hoje]}');
    }
    return;
  }

  void parentchange(List<String> liststring) {
    eventidsStrings.clear();
    eventidsStrings = liststring;
    eventschange.value = true;
    //eventschange.notifyListeners();
    //print('$eventidsStrings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 42, 54),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
          child: FutureBuilder(
              future: loadeventsmap(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Container(
                        child: Center(child: CircularProgressIndicator()));
                  case ConnectionState.waiting:
                    return Container(
                        child: Center(child: CircularProgressIndicator()));
                  case ConnectionState.active:
                    return Container(
                        child: Center(child: CircularProgressIndicator()));
                  case ConnectionState.done:
                    //eventschange.value = true;
                    return Container(
                      height: SizeConfig.maxHeight!,
                      //color: Colors.white,
                      child: Column(
                        children: [
                          Flexible(
                            flex: 6,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: CalendarTest(
                                  mapaeventos: mapaeventos,
                                  customFunction: parentchange),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 3 * SizeConfig.heightMultiplier!),
                              child: ValueListenableBuilder(
                                valueListenable: eventschange,
                                builder: (context, value, _) {
                                  eventschange.value = false;
                                  return eventidsStrings.isEmpty == false
                                      ? EventsDayList(
                                          listaEvent: eventidsStrings,
                                          teste: teste)
                                      : ContainerNoEventsThatDay();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                }
              }),
        ),
      ),
    );
  }

//Obter eventos de um dado mês (consoante dia)
  Future<List<Result>?> testediacalendar(DateTime day) async {
    var firstday = formatDate(day, [yyyy, '-', mm, '-', dd]);
    var lastday = formatDate(day, [yyyy, '-', mm, '-', dd]);
    Uri eventosapiUrl = Uri.parse(
        "http://vivaviseu.projectbox.pt/api/v1/events?start_date=${firstday}&end_date=${lastday}");
    print('Link utilizado para Eventos do mês ${day.month}: $eventosapiUrl');
    var resposta = await http.get(eventosapiUrl);
    if (resposta.statusCode == 200) {
      Map<String, dynamic> bodyy = json.decode(resposta.body);
      Welcome teste = Welcome.fromMap(bodyy);
      print("Numero de Eventos do mês ${day.month} : ${teste.result!.length}");
      int i;
      for (i = 0; i < teste.result!.length; i++) {
        print(
            '${teste.result![i].event!.id} , ${teste.result![i].event!.title} , Organizador: ${teste.result![i].event!.organizer!.name}');
      }
      numeroeventos = teste.getListEvents()!.length;
      return teste.result;
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    DateTime teste = DateTime(day.year, day.month, day.day);
    return mapaeventos[teste] ?? [];
  }
}

class CalendarTest extends StatefulWidget {
  const CalendarTest({
    Key? key,
    required this.mapaeventos,
    this.customFunction,
  }) : super(key: key);
  final LinkedHashMap<DateTime, List<Event>> mapaeventos;
  final customFunction;
  @override
  _CalendarTestState createState() => _CalendarTestState();
}

class _CalendarTestState extends State<CalendarTest> {
  var _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    print('[---------- Loading Eventos ----------]');
    super.initState();
    if (_getEventsForDay(_selectedDay).isNotEmpty) {
      widget.customFunction(buildListEvent(_getEventsForDay(_selectedDay)));
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    DateTime teste = DateTime(day.year, day.month, day.day);
    //print(' $day ------------ ${mapaeventos.containsKey(teste)}');
    return widget.mapaeventos[teste] ?? [];
  }

  late List<String> listaEvent;
  List<String> buildListEvent(List<Event>? Eventos) {
    if (Eventos == null) {
      return [];
    } else {
      listaEvent = [];
    }
    for (var i = 0; i < Eventos.length; i++) {
      String id = Eventos[i].id.toString();
      listaEvent.add(id);
    }
    return listaEvent;
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedDay == DateTime.now()) {
      setState(() {
        widget.customFunction(buildListEvent(_getEventsForDay(_selectedDay)));
      });
    }
    //buildListEvent(_getEventsForDay(_selectedDay));
    return Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 47, 59, 76),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        height: SizeConfig.maxHeight! * 0.45,
        width: SizeConfig.maxWidth!,
        child: TableCalendar(
          locale: 'pt_PT',
          firstDay: DateTime.utc(2021, 4, 1),
          lastDay: DateTime.utc(2030, 3, 14),
          startingDayOfWeek: StartingDayOfWeek.monday,
          focusedDay: _focusedDay,
          sixWeekMonthsEnforced: true,
          //rowHeight: SizeConfig.heightMultiplier! * 4.9,
          rowHeight: SizeConfig.heightMultiplier! * 5.1,
          shouldFillViewport: true,
          //estilo cores
          //
          //
          //estilo de texto da linha dias da semana
          daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              weekendStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              dowTextFormatter: (date, locale) =>
                  formatDate(date, [D], locale: PortugueseDateLocale())),
          //Header da Tabela
          headerStyle: HeaderStyle(
            titleCentered: true,
            titleTextFormatter: (date, locale) => formatDate(
                date, [MM, " ", yyyy],
                locale: PortugueseDateLocale()),
            titleTextStyle: Theme.of(context).textTheme.headline2!.copyWith(
                fontSize: 2 * SizeConfig.textMultiplier!,
                fontWeight: FontWeight.bold),
            formatButtonVisible: false,
            leftChevronIcon: Image.asset(
              'assets/images/icons/leftchevron.png',
              height: SizeConfig.imageSizeMultiplier! * 4,
            ),
            leftChevronPadding: EdgeInsets.only(
                left: 30 * SizeConfig.widthMultiplier!,
                top: 1.1 * SizeConfig.heightMultiplier!,
                bottom: 1.1 * SizeConfig.heightMultiplier!),
            rightChevronIcon: Image.asset(
              'assets/images/icons/rightchevron.png',
              height: SizeConfig.imageSizeMultiplier! * 4,
            ),
            rightChevronPadding: EdgeInsets.only(
                right: 30 * SizeConfig.widthMultiplier!,
                top: 1.1 * SizeConfig.heightMultiplier!,
                bottom: 1.1 * SizeConfig.heightMultiplier!),
          ),
          calendarFormat: CalendarFormat.month,
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            todayTextStyle: TextStyle(
              color: Color.fromRGBO(233, 168, 3, 1),
            ),
            todayDecoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(color: Colors.white),
            defaultTextStyle: TextStyle(color: Colors.white),
            markersMaxCount: 4,
            markerMargin:
                EdgeInsets.only(top: SizeConfig.heightMultiplier! * 0.5),
            markersAlignment: Alignment.bottomCenter,
            canMarkersOverflow: false,
            markerDecoration: BoxDecoration(
              color: Color.fromRGBO(233, 168, 3, 1),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(100),
              color: Color.fromRGBO(233, 168, 3, 1),
              shape: BoxShape.circle,
            ),
            //markerSizeScale: 0.1,
            markerSize: 5,
            //markersAutoAligned: true,
          ),
          eventLoader: _getEventsForDay,
          selectedDayPredicate: (selectedDay) {
            return isSameDay(_selectedDay, selectedDay);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              widget.customFunction(
                  buildListEvent(_getEventsForDay(_selectedDay)));
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = _selectedDay;
          },
        ));
  }
}

class EventsDayList extends StatefulWidget {
  const EventsDayList({
    Key? key,
    required this.teste,
    required this.listaEvent,
  }) : super(key: key);
  final List<String>? listaEvent;
  final UserPreferences teste;
  @override
  _EventsDayListState createState() => _EventsDayListState();
}

class _EventsDayListState extends State<EventsDayList> {
  String url = '';
  int numeroeventos = 0;
  late UserPreferences userpref;

  Future<List<Event>?> loadEventsFromDay(List<String> liststring) async {
    userpref = await UserPreferences();
    List<Event> eventosalistar = [];
    String url = 'http://vivaviseu.projectbox.pt/api/v1/events?event_list=';
    for (var i = 0; i < liststring.length; i++) {
      int getid = int.parse(liststring[i]);
      url = url + '$getid,';
    }
    if (url == 'http://vivaviseu.projectbox.pt/api/v1/events?event_list=') {
      return null;
    }
    Uri eventosdiaurl = Uri.parse(url);
    print('Link utilizado para Eventos Favoritos: $eventosdiaurl');
    var resposta = await http.get(eventosdiaurl); //trycatch
    Welcome Data = new Welcome();
    if (resposta.statusCode == 200) {
      Map<String, dynamic> body = json.decode(resposta.body);
      Data = Welcome.fromMap(body);
    }
    if (Data.result!.length > 0) {
      for (var i = 0; i < Data.result!.length; i++) {
        eventosalistar.add(Data.result![i].event!);
      }
    }
    numeroeventos = eventosalistar.length;
    return eventosalistar;
  }

  @override
  void initState() {
    print('[---------- A listar Eventos ----------]');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadEventsFromDay(widget.listaEvent!),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Container(
                height: 500,
                color: Colors.green,
                child: Center(child: CircularProgressIndicator()),
              );
            case ConnectionState.waiting:
              return Container(
                height: 500,
                child: Center(child: CircularProgressIndicator()),
              );
            case ConnectionState.active:
              return Container(
                height: 500,
                child: Center(child: CircularProgressIndicator()),
              );
            case ConnectionState.done:
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: false,
                  itemCount: numeroeventos,
                  itemBuilder: (BuildContext context, int index) {
                    var event = snapshot.data[index];
                    var title = event.title;
                    var eventoid = event.id;
                    var location = event.location;
                    var timeStart = event.dates[0].date.timeStart;
                    var eventdate = event.dates[0].date.eventDate;
                    var image = 'http://${event.images[0].image.thumbnail}';
                    UserPreferences teste = widget.teste;
                    List<String> listcateg = [];
                    int numcateg = event.categories.length;
                    for (var i = 0; i < numcateg; i++) {
                      listcateg.add(event.categories[i].category.name);
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: SizeConfig.heightMultiplier! * 2),
                      child: GestureDetector(
                        onTap: () {
                          Router_.router.navigateTo(
                              context, '/eventdetails?eventoid=$eventoid');
                        },
                        child: WidgetImagemDetalhesEventos(
                          evento: event,
                          listacategorias: listcateg,
                          userPreferences: userpref,
                        ),
                      ),
                    );
                    /*EventContainerCalendar(
                        teste: teste,
                        image: image,
                        title: title,
                        location: location,
                        id: eventoid,
                        timeStart: timeStart,
                        eventdate: eventdate,
                        categorylist: listcateg);*/
                  });
          }
        });
  }
}

class EventContainerCalendar extends StatefulWidget {
  final int? id;
  final String? title;
  final String image;
  final String? location;
  final DateTime? timeStart;
  final DateTime? eventdate;
  final List<String?> categorylist;
  final UserPreferences teste;
  const EventContainerCalendar({
    Key? key,
    required this.teste,
    required this.image,
    required this.title,
    required this.location,
    required this.id,
    required this.timeStart,
    required this.eventdate,
    required this.categorylist,
  }) : super(key: key);
  @override
  _EventContainerCalendarState createState() => _EventContainerCalendarState();
}

class _EventContainerCalendarState extends State<EventContainerCalendar> {
  bool _favorite = true;
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
                                  /*loadUserData();
                                  addEventUserData(widget.id);*/
                                  widget.teste.isFavorito(widget.id!)
                                      ? widget.teste.removeFavorito(widget.id!)
                                      : widget.teste.addFavorito(widget.id!);
                                });
                              },
                              child: Image(
                                image: widget.teste.isFavorito(widget.id!) ==
                                        true
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
              Expanded(
                child: Container(
                    height: 95,
                    width: 258,
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
                                  categorytext: widget.categorylist[0]),
                              SizedBox(
                                width: 4,
                              ),
                              widget.categorylist.length > 1
                                  ? CategoryplusWidget(
                                      categorytext:
                                          '+${widget.categorylist.length - 1}')
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
                    )),
              )
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

class NoEventsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Center(
        child: Text(
          'Não Existem Eventos neste dia',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
