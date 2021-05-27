import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:vivaviseu/objects.dart';
import 'eventdetailsbackground.dart';
import 'eventdetailscontent.dart';
import 'package:http/http.dart' as http;

class EventDetails extends StatefulWidget {
  EventDetails({this.eventid});

  final int? eventid;

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  Event? _event;

  @override
  void initState() {
    print(
        '[---------- Página Detalhes de Evento ${widget.eventid} ----------]');
    int? id = widget.eventid;
    //loadEventDetails(id);
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
      return evento;
    }
  }

  @override
  Widget build(BuildContext context) {
    /*_event = loadEventDetails(widget.eventid) as Event;
    print('Cheguei aqui! ${_event.title}');
    print('passei');
    var image = 'https://${_event.images[0].image.thumbnail}';
    print('passei');
    print('build : $image');*/

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Router_.router.pop(context)),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: loadEventDetails(widget.eventid),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                      //mainAxisAlignment: MainAxisAlignment.start,
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
                EventDetailsContent(event: snapshot.data,),
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
  }
}
