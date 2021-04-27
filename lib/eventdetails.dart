import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'eventdetailsbackground.dart';
import 'eventdetailscontent.dart';

class EventDetails extends StatefulWidget {
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final eventId = 11;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed:() => Navigator.pop(context, false),),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [IconButton(icon: Icon(Icons.favorite), onPressed: (){}),],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              EventDetailsBackground(),
            ]),
            EventDetailsContent(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.calendar_view_day),
        onPressed: ()=>{},
      ),
    );
  }
}
