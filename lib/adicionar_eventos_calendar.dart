import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timezone/src/date_time.dart';
import 'package:vivaviseu/utils/location.dart';
import 'package:vivaviseu/utils/responsive.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:vivaviseu/objects.dart' as obj;
import 'package:vivaviseu/utils/utils.dart';

class TutorialOverlay extends ModalRoute<void> {
  late obj.Event _event;
  late DeviceCalendarPlugin _deviceCalendarPlugin;
  List<Calendar?> _Calendars = [];
  ValueNotifier<bool> update = ValueNotifier(false);
  late Calendar _selectedCalendar;
  late obj.DateDate _selectedDate;
  late String _selectedAlert;
  late AppLocation _appLocation;
  List<String> alertas = [
    'Não notificar',
    '1 hora antes',
    '1 dia antes',
    '1 semana antes',
    '1 mês antes',
  ];

  TutorialOverlay(obj.Event _evento) {
    print(
        "-----------Adicionar Evento ${_evento.id} Calendário Local ------------");
    print('teste 2001');
    _appLocation = AppLocation();
    this._event = _evento;
    _selectedAlert = alertas[0];
    _selectedDate = _event.dates![0].date!;
    this._deviceCalendarPlugin = DeviceCalendarPlugin();
    _retrieveCalendars();
  }

  void setSelectedDate(obj.DateDate newDate) {
    setState(() {
      this._selectedDate = newDate;
      print('Selected Date ${_selectedDate.eventDate}');
      update.value = true;
    });
  }

  void setSelectedAlerta(String newAlerta) {
    setState(() {
      this._selectedAlert = newAlerta;
      print('Selected Alerta ${_selectedAlert}');
      update.value = true;
    });
  }

  void setSelectedCalendar(Calendar newCalendar) {
    setState(() {
      this._selectedCalendar = newCalendar;
      print('Selected Calendar ${_selectedCalendar.name}');
      update.value = true;
    });
  }

  void _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      setState(() {
        _Calendars = calendarsResult.data!;
        _selectedCalendar = _Calendars[0]!;
        update.value = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.widthMultiplier! * 7,
              right: SizeConfig.widthMultiplier! * 7),
          child: _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Color.fromRGBO(52, 66, 86, 1),
        ),
        height: SizeConfig.maxHeight! * 0.7,
        width: SizeConfig.maxWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                flex: 2,
                child: TextImage(
                    context) /*Container(
                color: Colors.yellow,
                child: Image.asset(
                  'assets/images/icons/icon_addtocalendar.png',
                  //scale: SizeConfig.imageSizeMultiplier! * 0.25,
                ),
              ),*/
                ),
            Flexible(
              flex: 8,
              child: ValueListenableBuilder(
                valueListenable: update,
                builder: (BuildContext context, bool value, Widget? child) {
                  update.value = false;
                  return options(context);
                },
              ),
            ),
            //Flexible(flex: 2, child: options(context)),
            Flexible(flex: 3, child: submitcancelbuttons(context, _event))
          ],
        ),
      ),
    );
  }

  Widget TextImage(BuildContext context) {
    return Container(
      width: SizeConfig.maxWidth,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: SizeConfig.heightMultiplier! * 5,
              width: SizeConfig.heightMultiplier! * 5,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(234, 168, 4, 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/icons/icon_addtocalendar.png',
                    height: SizeConfig.heightMultiplier! * 4,
                    fit: BoxFit.fitHeight,
                  )),
            ),
            SizedBox(
              width: SizeConfig.widthMultiplier! * 4,
            ),
            Text(
              'Adicionar ao Calendário',
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontSize: SizeConfig.heightMultiplier! * 2.1),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget options(BuildContext context) {
    return Container(
      width: SizeConfig.maxWidth,
      color: Color.fromRGBO(48, 58, 77, 1),
      child: Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.widthMultiplier! * 6,
            right: SizeConfig.widthMultiplier! * 6,
            top: SizeConfig.heightMultiplier! * 1.5,
            bottom: SizeConfig.heightMultiplier! * 1.5),
        child: Container(
          color: Color.fromRGBO(48, 58, 77, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(flex: 2, child: SelectCalendar(context)),
              Flexible(flex: 3, child: SelectDate(context)),
              /*Text(
                'Selecione a data do evento',
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier! * 2,
                    bottom: SizeConfig.heightMultiplier! * 2),
                child: Container(
                  height: SizeConfig.heightMultiplier! * 4,
                  /*width: SizeConfig.maxWidth,*/
                  child: _event.hasRecurringDates == false
                      ? GestureDetector(
                          onTap: () {
                            setSelectedDate(_event.dates![0].date!);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: SizeConfig.widthMultiplier! * 2.5,
                            ),
                            child: Container(
                              height: SizeConfig.heightMultiplier! * 2,
                              color: Color.fromRGBO(233, 168, 3, 1.0),
                              child: Padding(
                                padding: EdgeInsets.all(
                                    SizeConfig.widthMultiplier! * 1.5),
                                child: Text(
                                  formatDate(_event.dates![0].date!.eventDate!,
                                          [dd]) +
                                      ' de ' +
                                      formatDate(
                                          _event.dates![0].date!.eventDate!,
                                          [MM],
                                          locale: PortugueseDateLocale()) +
                                      ' ' +
                                      formatDate(
                                          _event.dates![0].date!.eventDate!,
                                          [yyyy]),
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                            ),
                          ),
                        )
                      : ListWheelScrollView(
                          magnification: 1,
                          itemExtent: 30,
                          children: [
                            Text('123'),
                            Text('123'),
                            Text('123'),
                          ],
                          useMagnifier: true,
                        ),*/
              /*ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _event.dates!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setSelectedDate(_event.dates![index].date!);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: SizeConfig.widthMultiplier! * 2.5,
                                ),
                                child: Container(
                                  height: SizeConfig.heightMultiplier! * 2,
                                  color:
                                      _selectedDate == _event.dates![index].date
                                          ? Color.fromRGBO(233, 168, 3, 1.0)
                                          : Colors.transparent,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          SizeConfig.widthMultiplier! * 1.5),
                                      child: Text(
                                        formatDate(
                                                _event.dates![index].date!
                                                    .eventDate!,
                                                [dd]) +
                                            ' de ' +
                                            formatDate(
                                                _event.dates![index].date!
                                                    .eventDate!,
                                                [MM],
                                                locale: PortugueseDateLocale()) +
                                            ' ' +
                                            formatDate(
                                                _event.dates![index].date!
                                                    .eventDate!,
                                                [yyyy]),
                                        style:
                                            Theme.of(context).textTheme.headline4,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                ),
              ),*/
              Flexible(flex: 2, child: SelectAlert(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget SelectCalendar(
    BuildContext context,
  ) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(bottom: SizeConfig.heightMultiplier!),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecione o calendário',
              style: Theme.of(context).textTheme.headline4,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier! * 2,
                  bottom: SizeConfig.heightMultiplier! * 2),
              child: Container(
                height: SizeConfig.heightMultiplier! * 4,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _Calendars.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setSelectedCalendar(_Calendars[index]!);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: SizeConfig.widthMultiplier! * 2.5,
                          ),
                          child: Container(
                            //height: SizeConfig.heightMultiplier! * 1,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              color:
                                  _selectedCalendar.id == _Calendars[index]!.id
                                      ? Color.fromRGBO(234, 168, 4, 1.0)
                                      : Color.fromRGBO(57, 71, 91, 1),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: SizeConfig.widthMultiplier! * 3,
                                left: SizeConfig.widthMultiplier! * 3,
                              ),
                              child: Center(
                                child: Text(
                                  _Calendars[index]!.name!,
                                  style: Theme.of(context).textTheme.headline4!,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget TextDate(BuildContext context, obj.DateDate date, bool selected) {
    print('A construir widget Text');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          formatDate(date.eventDate!, [dd]) +
              ' ' +
              formatDate(date.eventDate!, [MM],
                  locale: PortugueseDateLocale()) +
              ' ' +
              formatDate(date.eventDate!, [yyyy]),
          style: Theme.of(context).textTheme.headline4!.copyWith(
              color: selected == true
                  ? Color.fromRGBO(234, 168, 4, 1.0)
                  : Color.fromRGBO(131, 137, 148, 1)),
        ),
        SizedBox(
          width: SizeConfig.widthMultiplier! * 3,
        ),
        Text(
          formatDate(date.timeStart!, [HH]) +
              ' : ' +
              formatDate(date.timeStart!, [nn]),
          style: Theme.of(context).textTheme.headline4!.copyWith(
              color: selected == true
                  ? Color.fromRGBO(234, 168, 4, 1.0)
                  : Color.fromRGBO(131, 137, 148, 1)),
        )
      ],
    );
  }

  Widget SelectDate(BuildContext context) {
    int selected = 0;
    bool show = true;
    return Container(
      width: SizeConfig.maxWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecione a data do evento',
            style: Theme.of(context).textTheme.headline4,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.heightMultiplier! * 2,
                bottom: SizeConfig.heightMultiplier! * 2),
            child: Center(
              child: Container(
                  width: SizeConfig.maxWidth,
                  height: SizeConfig.heightMultiplier! * 8,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 20, //SizeConfig.heightMultiplier! * 3,
                    useMagnifier: false,
                    magnification: 1,
                    //perspective: 0.01,
                    physics: FixedExtentScrollPhysics(),
                    overAndUnderCenterOpacity: 0.7,
                    restorationId: selected.toString(),
                    onSelectedItemChanged: (index) {
                      selected = index;
                      setSelectedDate(_event.dates![selected].date!);
                      print('Item selected: $selected');
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                        childCount: _event.dates!.length,
                        builder: (BuildContext context, int index2) {
                          /*if (_event.hasRecurringDates == false) {
                        return Text(
                          _event.dates![0].date!.eventDate.toString(),
                          style: TextStyle(
                            color: _event.dates!.indexOf(_event.dates![0]) ==
                                    selected
                                ? Colors.orange
                                : Colors.white,
                          ),
                        );
                      } else {*/
                          if (_event.hasRecurringDates == true) {
                            bool isselected;
                            _selectedDate == _event.dates![index2].date
                                ? isselected = true
                                : isselected = false;
                            return TextDate(context,
                                _event.dates![index2].date!, isselected);
                          } else if (show == true) {
                            bool isselected;
                            _selectedDate == _event.dates![0].date
                                ? isselected = true
                                : isselected = false;
                            show = false;
                            return TextDate(
                                context, _event.dates![0].date!, isselected);
                          }
                        }),
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget SelectAlert(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notificar-me',
            style: Theme.of(context).textTheme.headline4,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.heightMultiplier! * 2,
                bottom: SizeConfig.heightMultiplier! * 0),
            child: Container(
              height: SizeConfig.heightMultiplier! * 4,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: alertas.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setSelectedAlerta(alertas[index]);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: SizeConfig.widthMultiplier! * 2.5,
                        ),
                        child: Container(
                          height: SizeConfig.heightMultiplier! * 2,
                          decoration: BoxDecoration(
                              color: _selectedAlert == alertas[index]
                                  ? Color.fromRGBO(234, 168, 4, 1.0)
                                  : Color.fromRGBO(57, 71, 91, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: SizeConfig.widthMultiplier! * 3,
                                  left: SizeConfig.widthMultiplier! * 3),
                              child: Text(
                                alertas[index],
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget submitcancelbuttons(BuildContext context, obj.Event eventdisplayed) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(48, 58, 77, 1),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Container(
              height: SizeConfig.heightMultiplier! * 7,
              width: SizeConfig.maxWidth! * 0.6,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(233, 168, 3, 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(35))),
              child: RawMaterialButton(
                  onPressed: () async {
                    ///////////////////////Se for evento Continuooo
                    ///
                    if (_event.hasRecurringDates == false) {
                      final evento = new Event(_selectedCalendar.id,
                          availability: Availability.Busy);
                      evento.description = eventdisplayed.description;
                      evento.title = eventdisplayed.title;
                      evento.location = eventdisplayed.location;
                      evento.recurrenceRule =
                          RecurrenceRule(RecurrenceFrequency.Daily,endDate:_event.dates![1].date!.eventDate);
                      ///////////////////Dados de inicio de evento
                      int startday =
                          int.parse(formatDate(_selectedDate.eventDate!, [dd]));
                      int startmonth =
                          int.parse(formatDate(_selectedDate.eventDate!, [mm]));
                      int startyear = int.parse(
                          formatDate(_selectedDate.eventDate!, [yyyy]));
                      int starthour =
                          int.parse(formatDate(_selectedDate.timeStart!, [H]));
                      int startminute =
                          int.parse(formatDate(_selectedDate.timeStart!, [n]));
                      print(
                          'Inicio Evento $startyear $startmonth $startday $starthour $startminute');
                      evento.start = TZDateTime(
                          _appLocation.getLocation()!,
                          startyear,
                          startmonth,
                          startday,
                          starthour,
                          startminute);
                      _appLocation.getLocation();
                      ///////////////////Alertas
                      if (_selectedAlert != alertas[0]) {
                        List<Reminder> Alertas = [];
                        Alertas.add(Reminder(
                            minutes: getReminderMinutes(_selectedAlert, alertas,
                                startyear, startmonth)));
                        print('Alertas 3 -> ${Alertas[0].minutes}');
                        evento.reminders = Alertas;
                      }
                      ///////////////////Dados de fim de evento
                      int endday = int.parse(
                          formatDate(_event.dates![1].date!.eventDate!, [dd]));
                      int endmonth = int.parse(
                          formatDate(_event.dates![1].date!.eventDate!, [mm]));
                      int endyear = int.parse(formatDate(
                          _event.dates![1].date!.eventDate!, [yyyy]));
                      int endhour = int.parse(
                          formatDate(_event.dates![1].date!.timeStart!, [H]));
                      int endminute = int.parse(
                          formatDate(_event.dates![1].date!.timeStart!, [n]));
                      if (checkenddatebeforestartdate(
                          startyear,
                          startmonth,
                          startday,
                          starthour,
                          startminute,
                          endyear,
                          endmonth,
                          endday,
                          endhour,
                          endminute)) {
                        if (endminute == 0 && endhour == 0) {
                          endminute = 59;
                        }
                        if (endhour == 0) {
                          endhour = 23;
                        }
                      }
                      evento.end = TZDateTime(_appLocation.getLocation()!,
                          endyear, endmonth, endday, endhour, endminute);
                      //////////////Criaçao evento
                      var createEventResult = await _deviceCalendarPlugin
                          .createOrUpdateEvent(evento);
                      if (createEventResult?.isSuccess == true) {
                        Navigator.pop(context, true);
                      } else {
                        print(createEventResult?.errors
                            .map((err) =>
                                '[${err.errorCode}] ${err.errorMessage}')
                            .join(' | ') as String);
                      }
                      print(
                          'Evento ${eventdisplayed.id} adicionado ao calendário do dispositivo!!');
                      return;
                    }

                    ///
                    ///
                    ////////
                    final evento = new Event(_selectedCalendar.id,
                        availability: Availability.Busy);
                    evento.description = eventdisplayed.description;
                    evento.title = eventdisplayed.title;
                    evento.location = eventdisplayed.location;
                    ///////////////////Dados de inicio de evento
                    int startday =
                        int.parse(formatDate(_selectedDate.eventDate!, [dd]));
                    int startmonth =
                        int.parse(formatDate(_selectedDate.eventDate!, [mm]));
                    int startyear =
                        int.parse(formatDate(_selectedDate.eventDate!, [yyyy]));
                    int starthour =
                        int.parse(formatDate(_selectedDate.timeStart!, [H]));
                    int startminute =
                        int.parse(formatDate(_selectedDate.timeStart!, [n]));
                    print(
                        'Inicio Evento $startyear $startmonth $startday $starthour $startminute');
                    evento.start = TZDateTime(
                        _appLocation.getLocation()!,
                        startyear,
                        startmonth,
                        startday,
                        starthour,
                        startminute);
                    ///////////////////Alertas
                    if (_selectedAlert != alertas[0]) {
                      List<Reminder> Alertas = [];
                      Alertas.add(Reminder(
                          minutes: getReminderMinutes(
                              _selectedAlert, alertas, startyear, startmonth)));
                      print('Alertas 3 -> ${Alertas[0].minutes}');
                      evento.reminders = Alertas;
                    }
                    ///////////////////Dados de fim de evento
                    int endday =
                        int.parse(formatDate(_selectedDate.eventDate!, [dd]));
                    int endmonth =
                        int.parse(formatDate(_selectedDate.eventDate!, [mm]));
                    int endyear =
                        int.parse(formatDate(_selectedDate.eventDate!, [yyyy]));
                    int endhour =
                        int.parse(formatDate(_selectedDate.timeEnd!, [H]));
                    int endminute =
                        int.parse(formatDate(_selectedDate.timeEnd!, [n]));
                    if (checkenddatebeforestartdate(
                        startyear,
                        startmonth,
                        startday,
                        starthour,
                        startminute,
                        endyear,
                        endmonth,
                        endday,
                        endhour,
                        endminute)) {
                      if (endminute == 0 && endhour == 0) {
                        endminute = 59;
                      }
                      if (endhour == 0) {
                        endhour = 23;
                      }
                    }
                    evento.end = TZDateTime(_appLocation.getLocation()!,
                        endyear, endmonth, endday, endhour, endminute);

                    ///////////////////Criação de evento no dispositivo
                    print(
                        'Inicio Evento $startyear $startmonth $startday $starthour $startminute');
                    print(
                        'Fim Evento $endyear $endmonth $endday $endhour $endminute');
                    print('ID CALENDAR ${_selectedCalendar.id}');
                    var createEventResult =
                        await _deviceCalendarPlugin.createOrUpdateEvent(evento);
                    if (createEventResult?.isSuccess == true) {
                      Navigator.pop(context, true);
                    } else {
                      print(createEventResult?.errors
                          .map(
                              (err) => '[${err.errorCode}] ${err.errorMessage}')
                          .join(' | ') as String);
                    }
                    print(
                        'Evento ${eventdisplayed.id} adicionado ao calendário do dispositivo!!');
                    return;
                  },
                  child: Text(
                    'Adicionar Evento',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontSize: 2 * SizeConfig.textMultiplier!),
                  )),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancelar',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontSize: 2 * SizeConfig.textMultiplier!),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(opacity: animation, child: child);
  }
}
