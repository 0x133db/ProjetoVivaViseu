import 'package:flutter/material.dart';

import 'config/router.dart';

class AllEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: TextButton(
        onPressed: (){
          //Router_.router.navigateTo(context, '/');
          Router_.router.pop(context);
        },
        child: Text(
          'Voltar',
        ),
      ),
    );
  }
}