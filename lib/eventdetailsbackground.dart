import 'package:flutter/material.dart';

class EventDetailsBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final eventId = 11;

    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Stack(
            children: [Image.network(
              'http://oceancoastfilmfest.com/wp-content/uploads/2020/12/Thumbnail-Int.-1.jpg',
              width: screenWidth,
              height: screenHeight * 0.5 ,
              fit: BoxFit.cover,
              //color: Color(0x99000000),
              //colorBlendMode: BlendMode.dstOut,
              ),
            ]
          ),
        ),
      ],
    );
  }
}
