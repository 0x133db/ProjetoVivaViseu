import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:vivaviseu/objects.dart';
import 'package:vivaviseu/utils/utils.dart';
import 'eventdetailsbackground.dart';
import 'eventdetailscontent.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDetails extends StatefulWidget {
  EventDetails({this.eventid,this.eventfavorite});
  final int? eventfavorite;
  final int? eventid;

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  Event? _event;
  late UserPreferences _userPreferences;
  late bool eventfavorite;

  @override
  void initState() {
    print(
        '[---------- Página Detalhes de Evento ${widget.eventid} ----------]');
            print(
        '[---------- Página Detalhes de Evento ${widget.eventfavorite} ----------]');
    if(widget.eventfavorite == 0){
    eventfavorite = true;
    }else{
      eventfavorite = false;
    }
    super.initState();
  }

  Future<Event?> loadEventDetails(int? id) async {
    Uri eventoapiUrl =
        Uri.parse("http://vivaviseu.projectbox.pt/api/v1/events/$id");
    print('Link utilizado: $eventoapiUrl');
    var resposta = await http.get(eventoapiUrl);
    if (resposta.statusCode == 200) {
      Map<String, dynamic> bodyy = json.decode(resposta.body);
      Result _result = Result.fromMap(bodyy);
      int i;
      print(
          '[ID]: ${_result.event!.id} , Título: ${_result.event!.title} , Descrição: ${_result.event!.description}');
      Event? evento = _result.event;
      _event = _result.event;
      return evento;
    }
  }

  @override
  Widget build(BuildContext context) {
    _userPreferences = UserPreferences();
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Router_.router.pop(context)),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          actions: [
            IconButton(
                icon: eventfavorite == true 
                    ? Image.asset(
                        'assets/images/icons/icon_favorites.png',
                      )
                    : Image.asset(
                        'assets/images/icons/icon_favorite.png',),
                      
                onPressed: () {
                  setState(() {
                  _userPreferences.isFavorito(_event!.id!) == true ? _userPreferences.removeFavorito(_event!.id!) :
                  _userPreferences.addFavorito(_event!.id!);                                        
                               });
                }),
          ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: loadEventDetails(widget.eventid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              _event = snapshot.data;
              var thumbnail =
                  'http://vivaviseu.projectbox.pt${snapshot.data.images[0].image.fullHd}';
              var titulo = '${snapshot.data.title}';
              var data = '${snapshot.data.startDate}';
              var horainicio = '${snapshot.data.dates[0].date.timeStart}';
              var localizacao = '${snapshot.data.location}';

              return Column(
                children: [
                  Stack(alignment: AlignmentDirectional.bottomStart, children: [
                    EventDetailsBackground(image: thumbnail),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titulo,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/icons/icon_eventdetailscalendar.png',
                                scale: 2,
                              ),
                              Text(
                                data,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Image.asset(
                                'assets/images/icons/icon_eventdetailswatch.png',
                                scale: 2,
                              ),
                              Text(
                                horainicio,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/icons/icon_eventdetailslocation.png',
                                scale: 2,
                              ),
                              Text(
                                localizacao,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ]),
                  EventDetailsContent(
                    event: snapshot.data,
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.calendar_view_day),
          onPressed: () => {},
        ),
      );
    });
  }
}
