import 'package:flutter/material.dart';
import 'style.dart';
import 'responsive.dart';

class ContainerNetworkError extends StatelessWidget {
  const ContainerNetworkError({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'No Internet Connection',
        style: AppTheme.TextStyleTheme.headline2,
      ),
    );
  }
}