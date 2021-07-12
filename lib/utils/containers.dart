import 'package:flutter/material.dart';
import 'style.dart';
import 'responsive.dart';

class ContainerNetworkError extends StatelessWidget {
  const ContainerNetworkError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.widthMultiplier! * 15,
          right: SizeConfig.widthMultiplier! * 15,
          top: SizeConfig.heightMultiplier! * 3),
      child: Container(
        height: SizeConfig.maxHeight,
        width: SizeConfig.maxWidth,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/icons/network.png',
              height: SizeConfig.heightMultiplier! * 30,
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.heightMultiplier! * 3),
              child: Text(
                'Sem ligação à Internet!',
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 2.3 * SizeConfig.textMultiplier!),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.heightMultiplier! * 1),
              child: Text(
                'Por favor, verifique a sua conexão à internet e tente novamente.',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class ContainerGeneralError extends StatelessWidget {
  const ContainerGeneralError({Key? key}) : super(key: key);

  @override
    Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.widthMultiplier! * 15,
          right: SizeConfig.widthMultiplier! * 15,
          top: SizeConfig.heightMultiplier! * 3),
      child: Container(
        height: SizeConfig.maxHeight,
        width: SizeConfig.maxWidth,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/icons/erros.png',
              height: SizeConfig.heightMultiplier! * 30,
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.heightMultiplier! * 3),
              child: Text(
                'Oops ocorreu um erro!',
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 2.3 * SizeConfig.textMultiplier!),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.heightMultiplier! * 1),
              child: Text(
                'Por favor, tente novamente mais tarde.',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class ContainerNoEvents extends StatelessWidget {
  const ContainerNoEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.widthMultiplier! * 15,
          right: SizeConfig.widthMultiplier! * 15,
          top: SizeConfig.heightMultiplier! * 3),
      child: Container(
        height: SizeConfig.maxHeight,
        width: SizeConfig.maxWidth,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.heightMultiplier! * 3),
              child: Text(
                'Oops!',
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 2.3 * SizeConfig.textMultiplier!),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.heightMultiplier! * 1),
              child: Text(
                'Neste momento não existem eventos.',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )),
      ),
    );
  }
}


class ContainerNoEventsThatDay extends StatelessWidget {
  const ContainerNoEventsThatDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.widthMultiplier! * 15,
          right: SizeConfig.widthMultiplier! * 15,
          top: SizeConfig.heightMultiplier! * 1),
      child: Container(
        height: SizeConfig.maxHeight,
        width: SizeConfig.maxWidth,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.heightMultiplier! * 1),
              child: Text(
                'Oops!',
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 2.3 * SizeConfig.textMultiplier!),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.heightMultiplier! * 1),
              child: Text(
                'Neste dia não existem eventos...',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class ContainerNoHighlights extends StatelessWidget {
  const ContainerNoHighlights({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.widthMultiplier! * 15,
          right: SizeConfig.widthMultiplier! * 15,
          ),
      child: Container(
        height: SizeConfig.maxHeight,
        width: SizeConfig.maxWidth,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Oops!',
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontSize: 2.3 * SizeConfig.textMultiplier!),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.heightMultiplier! * 1),
              child: Text(
                'Neste momento não existem eventos em destaque.',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )),
      ),
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
