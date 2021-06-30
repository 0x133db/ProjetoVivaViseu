import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EventDetailsBackground extends StatelessWidget {
  EventDetailsBackground({this.image});

  final String? image;

  @override
  Widget build(BuildContext context) {

      return Stack(
        children: [Image.network(
          '$image',
          //width: screenWidth,
          //height: screenHeight * 0.5 ,
          height: 400,
          fit: BoxFit.fitHeight,
          //color: Color(0x99000000),
          //colorBlendMode: BlendMode.dstOut,
          ),
        ]
      );
  }
}
