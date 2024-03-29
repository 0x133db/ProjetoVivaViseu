import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vivaviseu/favorites.dart';
import 'package:vivaviseu/utils/responsive.dart';
import 'package:vivaviseu/utils/utils.dart';

class EventoContainerNoDate extends StatefulWidget {
  final UserPreferences userPreferences;
  final int? id;
  final String? title;
  final String image;
  final String? location;
  final DateTime? timeStart;
  final DateTime? eventdate;
  final bool imagebool;
  final List<String?> categorylist;
  const EventoContainerNoDate({
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
  _EventoContainerNoDate createState() => _EventoContainerNoDate();
}

class _EventoContainerNoDate extends State<EventoContainerNoDate> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      print(
          'EventContainerNoDate################# ${constraints.maxHeight} ############## ${constraints.minWidth}');
      return Container(
        //color: Colors.green,
        height: double.maxFinite,
        width: constraints.minWidth,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            EventDateInfo(
                eventdate: widget.eventdate, imagebool: widget.imagebool),
            EventImage(
              up: widget.userPreferences,
              image: widget.image,
            ),
            EventContainerDetails(
                /*userPreferences: widget.userPreferences,
            id: widget.id,
            title: widget.title,
            location: widget.location,
            image: widget.image,
            timeStart: widget.timeStart,
            listaCategorias: widget.categorylist,*/
                ),
          ],
        ),
      );
    });
  }
}

class EventDateInfo extends StatelessWidget {
  final DateTime? eventdate;
  final bool imagebool;
  const EventDateInfo({
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
      height:
          MediaQuery.of(context).size.height * 0.165, //altura do container data
      width: MediaQuery.of(context).size.width * 0.15, //largura container data
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

class EventImage extends StatefulWidget {
  const EventImage({Key? key, required this.image, required this.up})
      : super(key: key);
  final String image;
  final UserPreferences up;

  @override
  _EventImageState createState() => _EventImageState();
}

class _EventImageState extends State<EventImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: 110,
      child: Image.network(
        widget.image,
        fit: BoxFit.cover,
      ),
    );
  }
}

class EventContainerDetails extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<EventContainerDetails> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, um, dois) {
      //print('EventContainerDetails ################# ${constraints.maxHeight} ############## ${constraints.maxWidth}');
      print('EventContainerDetails ################# ${h} ############## ${w}');
      return Container(
        height: 100.h,
        width: 100.w,
        color: Colors.red,
        child: Text('Teste'),
      );
    });
  }
}
