//import 'dart:html';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vivaviseu/objects.dart';
import 'package:http/http.dart' as http;

int num =0;

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  //CalendarController _calendarController = CalendarController();
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 42, 54),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CalendarEvents(),
            SizedBox(height: 15,),
            EventsOnThisDay(),
            //Text(_dateTime == null ? 'Nada' : _dateTime.toString()),
            //Text('$screenWidth , $screenHeight'),
          ],
        ),
      ),
    );
  }

  Widget CalendarEvents() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 47, 59, 76),
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        //color: Color.fromARGB(255, 47, 59, 76),
        //height: screenHeight / 2.4,
        width: screenWidth,
        child: TableCalendar(
          firstDay: DateTime.utc(2021, 4, 1),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _dateTime,
          sixWeekMonthsEnforced: true,
          headerStyle: HeaderStyle(
          ),
        ),
    );
  }

  Widget EventsOnThisDay(){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child:  Card(
          color: Color.fromARGB(255, 47, 59, 76),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                color: Color.fromARGB(255, 34, 42, 54),
                height: screenHeight / 8,
                width: screenWidth,
                //child: Text('${screenHeight/8}'),
              ),
              Container(
                color: Color.fromARGB(255, 47, 59, 76),
                height: screenHeight/10,
                width: screenWidth,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  //color: Colors.black,
                ),
                height: screenHeight / 8,
                width: screenWidth / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image.network('http://oceancoastfilmfest.com/wp-content/uploads/2020/12/Thumbnail-Int.-1.jpg',
                    fit: BoxFit.fitHeight,
                    
                    
                  ),
                ),
              ),
              /*Container(
                color: Colors.black,
                height: screenHeight/5,
                width: screenWidth / 4,
              ),*/
            ],
          ),
        ),
    );
  }
}
  Future<List<Result>> loadData() async {
    Uri eventosapiUrl =
        Uri.parse("http://vivaviseu.projectbox.pt/api/v1/highlighted_events");
    print('Link utilizado: $eventosapiUrl');
    var res = await http.get(eventosapiUrl);
    if (res.statusCode == 200) {
      Map<String, dynamic> bodyy = json.decode(res.body);
      Welcome teste = Welcome.fromMap(bodyy);
      print("lenght ${teste.result.length}");
      int i;
      for (i = 0; i < teste.result.length; i++) {
        print(
            '${teste.result[i].event.id} , ${teste.result[i].event.title} , Organizador: ${teste.result[i].event.organizer.name}');
      }
      num = teste.getListEvents().length;
      return teste.result;
    }
  }
