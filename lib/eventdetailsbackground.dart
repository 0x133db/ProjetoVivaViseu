import 'package:flutter/material.dart';

class EventDetailsBackground extends StatelessWidget {
  EventDetailsBackground({this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Stack(
            children: [Image.network(
              '$image',
              //width: screenWidth,
              //height: screenHeight * 0.5 ,
              height: 400,
              fit: BoxFit.fill,
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
