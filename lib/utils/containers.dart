import 'package:flutter/material.dart';
import 'style.dart';
import 'responsive.dart';

class ContainerNetworkError extends StatelessWidget {
  const ContainerNetworkError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.maxHeight,
      width: SizeConfig.maxWidth,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.network_locked,
            color: Colors.white,
          ),
          Padding(
           padding: EdgeInsets.all(SizeConfig.heightMultiplier! * 2),
            child: Text(
              'Sem ligação á Internet',
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )),
    );
  }
}

class ContainerGeneralError extends StatelessWidget {
  const ContainerGeneralError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.maxHeight,
      width: SizeConfig.maxWidth,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: Colors.white,
          ),
          Padding(
            padding: EdgeInsets.all(SizeConfig.heightMultiplier! * 2),
            child: Text(
              'Algo inesperado aconteceu',
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )),
    );
  }
}

class ContainerNoEvents extends StatelessWidget {
  const ContainerNoEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.maxHeight,
      width: SizeConfig.maxWidth,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(SizeConfig.heightMultiplier! * 2),
            child: Text(
              'Não existem eventos disponíveis',
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )),
    );
  }
}


class ContainerNoHighlights extends StatelessWidget {
  const ContainerNoHighlights({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.maxHeight,
      width: SizeConfig.maxWidth,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(SizeConfig.heightMultiplier! * 2),
            child: Text(
              'Não existem eventos em destaque',
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )),
    );
  }
}

class ContainerNoCategories extends StatelessWidget {
  const ContainerNoCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.maxHeight,
      width: SizeConfig.maxWidth,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(SizeConfig.heightMultiplier! * 2),
            child: Text(
              'Não existem categorias',
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )),
    );
  }
}

class ContainerNoSearchResults extends StatelessWidget {
  const ContainerNoSearchResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.maxHeight,
      width: SizeConfig.maxWidth,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(SizeConfig.heightMultiplier! * 2),
            child: Text(
              'Não foram encontrados eventos para a sua pesquisa',
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )),
    );
  }
}

