import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:device_calendar/device_calendar.dart' as devicecalendar;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vivaviseu/adicionar_eventos_calendar.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:vivaviseu/objects.dart';
import 'package:http/http.dart' as http;
import 'package:vivaviseu/utils/category.dart';
import 'package:vivaviseu/utils/responsive.dart';
import 'package:vivaviseu/utils/style.dart';
import 'package:vivaviseu/utils/utils.dart';
import 'favorites.dart';

class DetalhesEvento extends StatefulWidget {
  const DetalhesEvento({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _DetalhesEventoState createState() => _DetalhesEventoState();
}

class _DetalhesEventoState extends State<DetalhesEvento>
    with TickerProviderStateMixin {
  late GoogleMapController mapController;
  late BitmapDescriptor mapIcon;
  late UserPreferences userPref;

  //Teste
  /*
  late AnimationController _ColorAnimationController;
  late AnimationController _TextAnimationController;
  late Animation _colorTween, _iconColorTween;
  late Animation<Offset> _transTween;

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _ColorAnimationController.animateTo(scrollInfo.metrics.pixels / 350);

      _TextAnimationController.animateTo(
          (scrollInfo.metrics.pixels - 350) / 50);
      return true;
    }
    return false;
  }*/

  //

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Event?> loadEventDetails() async {
    userPref = await UserPreferences();
    Uri eventoapiUrl =
        Uri.parse("http://vivaviseu.projectbox.pt/api/v1/events/${widget.id}");
    print('Link utilizado: $eventoapiUrl');
    var resposta = await http.get(eventoapiUrl);
    if (resposta.statusCode == 200) {
      Map<String, dynamic> bodyy = json.decode(resposta.body);
      Result _result = Result.fromMap(bodyy);
      int i;
      print(
          '[ID]: ${_result.event!.id} , Título: ${_result.event!.title} , Descrição: ${_result.event!.description}');
      Event? evento = _result.event;
      return evento;
    }
  }

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)),
            'assets/images/icons/icon_mapa_marker.png')
        .then((onValue) {
      mapIcon = onValue;
    });

    //
    /*_ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Color(0xFFee4c4f))
        .animate(_ColorAnimationController);
    _iconColorTween = ColorTween(begin: Colors.grey, end: Colors.white)
        .animate(_ColorAnimationController);

    _TextAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _transTween = Tween(begin: Offset(-10, 40), end: Offset(-10, 0))
        .animate(_TextAnimationController);*/
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)),
            'assets/images/icons/icon_mapa_marker.png')
        .then((onValue) {
      mapIcon = onValue;
    });
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder(
          future: loadEventDetails(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Container(
                  color: Color.fromRGBO(47, 59, 77, 1),
                  child: Center(child: CircularProgressIndicator()),
                );
              case ConnectionState.waiting:
                return Container(
                  color: Color.fromRGBO(47, 59, 77, 1),
                  child: Center(child: CircularProgressIndicator()),
                );
              case ConnectionState.active:
                return Container(
                  color: Color.fromRGBO(47, 59, 77, 1),
                  child: Center(child: CircularProgressIndicator()),
                );
              case ConnectionState.done:
                Event _event = snapshot.data;
                double lat = double.parse(_event.latitude!);
                double long = double.parse(_event.longitude!);
                var _center = LatLng(lat, long);
                List<String> linkList = [];
                //////
                var linkss = _event.links;
                for (int i = 0; i < _event.links!.length; i++) {
                  linkList.add(linkss![i].link!.link!);
                }
                /////
                print('Link List $linkList');
                var fullHd =
                    'http://vivaviseu.projectbox.pt${_event.images![0].image!.fullHd}';
                //print('################################################${_event.links![0]}');
                return Scaffold(
                  backgroundColor: Color.fromRGBO(47, 59, 77, 1),
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    leading: Padding(
                      padding: EdgeInsets.only(
                          //right: SizeConfig.heightMultiplier! * 1
                          left: SizeConfig.heightMultiplier! * 1),
                      child: IconButton(
                        icon: Stack(children: [
                          Image.asset(
                            'assets/images/icons/icon_ellipse.png',
                            scale: 2.5,
                            width: 10 * SizeConfig.imageSizeMultiplier!,
                          ),
                          Positioned(
                            left: 0,
                            right: 3,
                            top: 0,
                            bottom: 0,
                            child: Image.asset(
                              'assets/images/icons/icon_backarrow.png',
                              scale: 2.2,
                              width: 10 * SizeConfig.imageSizeMultiplier!,
                            ),
                          )
                        ]),
                        onPressed: () => Router_.router.pop(context),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: SizeConfig.heightMultiplier! * 1),
                        child: IconFavoritoDetalhes(
                            userPref: userPref, event: _event),
                      ),
                    ],
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  body: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            Container(
                              height: SizeConfig.maxHeight! * 0.45,
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          SizeConfig.heightMultiplier! *
                                              1.11),
                                      bottomRight: Radius.circular(
                                          SizeConfig.heightMultiplier! *
                                              1.11))),
                              child: ShaderMask(
                                shaderCallback: (rect) {
                                  return LinearGradient(
                                      begin: Alignment(0, -0.3),
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppTheme.appBackgroundColor,
                                        Colors.transparent
                                      ]).createShader(Rect.fromLTRB(
                                      0, 0, rect.width, rect.height));
                                },
                                blendMode: BlendMode.dstIn,
                                child: Image.network(
                                  fullHd,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: SizeConfig.heightMultiplier! * 0.9,
                                left: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          SizeConfig.heightMultiplier! * 2,
                                      left: SizeConfig.widthMultiplier! * 7),
                                  child: Container(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(_event.title!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3),
                                          SizedBox(
                                            height:
                                                SizeConfig.heightMultiplier!,
                                          ),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/icons/icon_eventdetailscalendar.png',
                                                      height: SizeConfig
                                                              .imageSizeMultiplier! *
                                                          2.4,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: SizeConfig
                                                                  .widthMultiplier! *
                                                              1.5,
                                                          right: SizeConfig
                                                                  .widthMultiplier! *
                                                              5.5),
                                                      child: Text(
                                                          formatDate(
                                                                  _event
                                                                      .dates![0]
                                                                      .date!
                                                                      .eventDate!,
                                                                  [
                                                                    dd
                                                                  ]) +
                                                              ' de ' +
                                                              formatDate(
                                                                  _event.dates![0].date!.eventDate!, [MM],
                                                                  locale:
                                                                      PortugueseDateLocale()) +
                                                              ' ' +
                                                              formatDate(
                                                                  _event
                                                                      .dates![0]
                                                                      .date!
                                                                      .eventDate!,
                                                                  [
                                                                    yyyy
                                                                  ]),
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .headline4!
                                                              .copyWith(
                                                                  fontSize: 1.6 *
                                                                      SizeConfig.textMultiplier!)),
                                                    ),
                                                    Image.asset(
                                                      'assets/images/icons/icon_eventdetailswatch.png',
                                                      height: SizeConfig
                                                              .imageSizeMultiplier! *
                                                          2.4,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: SizeConfig
                                                                  .widthMultiplier! *
                                                              1.5,
                                                          right: SizeConfig
                                                                  .widthMultiplier! *
                                                              1),
                                                      child: Text(
                                                          formatDate(
                                                                  _event
                                                                      .dates![0]
                                                                      .date!
                                                                      .timeStart!,
                                                                  [
                                                                    HH
                                                                  ]) +
                                                              'h' +
                                                              formatDate(
                                                                  _event
                                                                      .dates![
                                                                          0]
                                                                      .date!
                                                                      .timeStart!,
                                                                  [
                                                                    nn
                                                                  ]),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline4!
                                                              .copyWith(
                                                                  fontSize: 1.6 *
                                                                      SizeConfig
                                                                          .textMultiplier!)),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: SizeConfig
                                                              .heightMultiplier! *
                                                          0.1),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/icons/icon_eventdetailslocation.png',
                                                        height: SizeConfig
                                                                .imageSizeMultiplier! *
                                                            2.4,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: SizeConfig
                                                                    .widthMultiplier! *
                                                                1.5,
                                                            right: SizeConfig
                                                                    .widthMultiplier! *
                                                                1),
                                                        child: Text(
                                                            _event.location!,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4!
                                                                .copyWith(
                                                                    fontSize: 1.6 *
                                                                        SizeConfig
                                                                            .textMultiplier!)),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                          /*Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                //color: Colors.yellow,
                                                height:
                                                    SizeConfig.heightMultiplier! *
                                                        4,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/icons/icon_eventdetailscalendar.png',
                                                      scale: 2.5,
                                                    ),
                                                    Image.asset(
                                                      'assets/images/icons/icon_eventdetailslocation.png',
                                                      scale: 2.5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    SizeConfig.widthMultiplier! *
                                                        2,
                                              ),
                                              Container(
                                                height:
                                                    SizeConfig.heightMultiplier! *
                                                        4,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                        formatDate(
                                                                _event
                                                                    .dates![0]
                                                                    .date!
                                                                    .eventDate!,
                                                                [dd]) +
                                                            ' de ' +
                                                            formatDate(
                                                                _event
                                                                    .dates![0]
                                                                    .date!
                                                                    .eventDate!,
                                                                [MM],
                                                                locale:
                                                                    PortugueseDateLocale()) +
                                                            ' ' +
                                                            formatDate(
                                                                _event
                                                                    .dates![0]
                                                                    .date!
                                                                    .eventDate!,
                                                                [yyyy]),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4),
                                                    Text(_event.location!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4),
                                                  ],
                                                ),
                                              ),
                                              ///////////////////////
                                              SizedBox(
                                                width:
                                                    SizeConfig.widthMultiplier! *
                                                        2,
                                              ),
                                              Container(
                                                  height: SizeConfig
                                                          .heightMultiplier! *
                                                      4,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/icons/icon_eventdetailswatch.png',
                                                        scale: 2.5,
                                                      ),
                                                      Text('  '),
                                                    ],
                                                  )),
                                              SizedBox(
                                                width:
                                                    SizeConfig.widthMultiplier! *
                                                        2,
                                              ),
                                              Container(
                                                  height: SizeConfig
                                                          .heightMultiplier! *
                                                      4,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(
                                                          formatDate(
                                                                  _event
                                                                      .dates![0]
                                                                      .date!
                                                                      .timeStart!,
                                                                  [HH]) +
                                                              'h' +
                                                              formatDate(
                                                                  _event
                                                                      .dates![0]
                                                                      .date!
                                                                      .timeStart!,
                                                                  [nn]),
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .headline4),
                                                      Text('  '),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        */
                                        ]),
                                  ),
                                ))
                          ]),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.heightMultiplier! * 1.5,
                                left: SizeConfig.widthMultiplier! * 7,
                                right: SizeConfig.widthMultiplier! * 7),
                            child: 
                              /*child:*/ SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                    height: SizeConfig.heightMultiplier! * 2.5,
                                    width: SizeConfig.maxWidth,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _event.categories!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var categoryname = _event
                                              .categories![index]
                                              .category!
                                              .name!;
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                right: SizeConfig
                                                        .widthMultiplier! *
                                                    3),
                                            child:
                                                /*CategoryBasic(
                                              name: categoryname,
                                            ),*/
                                                CategoryWidget(context,
                                                    categorytext: categoryname),
                                          );
                                        })),
                              ),
                            
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.heightMultiplier! * 2,
                                left: SizeConfig.widthMultiplier! * 7,
                                right: SizeConfig.widthMultiplier! * 7),
                            child: Text('Descrição',
                                style: Theme.of(context).textTheme.headline3),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.heightMultiplier! * 1.3,
                                left: SizeConfig.widthMultiplier! * 7,
                                right: SizeConfig.widthMultiplier! * 7,
                                bottom: SizeConfig.widthMultiplier! * 2),
                            child: Text(
                              '${_event.description}',
                              maxLines: 15,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier! * 2,
                              left: SizeConfig.widthMultiplier! * 7,
                              right: SizeConfig.widthMultiplier! * 7,
                            ),
                            child: Text("Localização",
                                style: Theme.of(context).textTheme.headline3),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.heightMultiplier! * 1.3,
                                left: SizeConfig.widthMultiplier! * 7,
                                right: SizeConfig.widthMultiplier! * 7,
                                bottom: SizeConfig.widthMultiplier! * 2),
                            child: Container(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight * 0.15,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                child: GoogleMap(
                                    onMapCreated: _onMapCreated,
                                    myLocationEnabled: true,
                                    markers: <Marker>{
                                      Marker(
                                          markerId:
                                              MarkerId(_event.id.toString()),
                                          position: _center,
                                          icon: mapIcon,
                                          infoWindow: InfoWindow(
                                              title: _event.title,
                                              snippet: _event.location))
                                    },
                                    initialCameraPosition: CameraPosition(
                                      target: _center,
                                      zoom: 12.0,
                                    )),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.heightMultiplier! * 2,
                                left: SizeConfig.widthMultiplier! * 7,
                                right: SizeConfig.widthMultiplier! * 7),
                            child: Text("Promotor",
                                style: Theme.of(context).textTheme.headline3),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.heightMultiplier! * 1.3,
                                left: SizeConfig.widthMultiplier! * 7,
                                right: SizeConfig.widthMultiplier! * 7,
                                bottom: SizeConfig.widthMultiplier! * 2),
                            child: Container(
                              height: SizeConfig.heightMultiplier! *
                                  6.5, //alterar
                              width: SizeConfig.maxWidth,
                              child: Row(
                                children: [
                                  ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100),
                                      child: Image.network(
                                        'http://${_event.organizer!.image}',
                                        height: SizeConfig.heightMultiplier! *
                                            5.9,
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            SizeConfig.widthMultiplier! * 3),
                                    child: Text(
                                      _event.organizer!.name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier! * 2,
                              left: SizeConfig.widthMultiplier! * 7,
                              right: SizeConfig.widthMultiplier! * 7,
                            ),
                            child: Text("Links",
                                style: Theme.of(context).textTheme.headline3),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier! * 1.3,
                              left: SizeConfig.widthMultiplier! * 7,
                              right: SizeConfig.widthMultiplier! * 7,
                              bottom: SizeConfig.heightMultiplier! * 2,
                            ),
                            child: Container(
                                height: SizeConfig.heightMultiplier! * 10,
                                width: SizeConfig.maxWidth,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.loose,
                                      child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          reverse: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: linkList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var categoryname = _event
                                                .categories![index]
                                                .category!
                                                .name!;
                                            return Padding(
                                                padding: EdgeInsets.only(
                                                    right: SizeConfig
                                                            .widthMultiplier! *
                                                        3),
                                                child: Links(
                                                    text: linkList[index])
                                                /*CategoryWidget(context,
                                                      categorytext: categoryname),*/
                                                );
                                          }),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        color: Colors.black,
                                        height:
                                            SizeConfig.heightMultiplier! * 10,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          /*Container(
                                        color: Colors.blue,
                                        height: SizeConfig.heightMultiplier! * 3,
                                        width: SizeConfig.maxWidth,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Image.asset(
                                                iconpath,
                                                height:
                                                    SizeConfig.heightMultiplier! *
                                                        2.9,
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  SizeConfig.widthMultiplier! * 2,
                                            ),
                                            Expanded(
                                              child: Text(
                                                linkList[index],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );*/
                          /*Padding(
                            padding: EdgeInsets.only(
                                //top: SizeConfig.heightMultiplier! * 1.3,
                                left: SizeConfig.widthMultiplier! * 7,
                                right: SizeConfig.widthMultiplier! * 7,
                                bottom: SizeConfig.widthMultiplier! * 2),
                            child: Container(
                              width: SizeConfig.maxWidth,
                              child: ListView.builder(
                                  itemCount: linkList.length,
                                  itemBuilder: (context, index) {
                                    final uri = Uri.parse(linkList[index]);
                                    String iconpath = getIconPath(uri);
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: SizeConfig.heightMultiplier! * 0.5,
                                          bottom:
                                              SizeConfig.heightMultiplier! * 0.5),
                                      child: Container(
                                        color: Colors.blue,
                                        width: SizeConfig.maxWidth,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              iconpath,
                                              height:
                                                  SizeConfig.heightMultiplier! *
                                                      2.9,
                                            ),
                                            SizedBox(
                                              width:
                                                  SizeConfig.widthMultiplier! * 2,
                                            ),
                                            Text(
                                              linkList[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),*/
                          Container(
                            height: constraints.maxHeight * 0.5,
                            width: constraints.maxWidth,
                          )
                        ],
                      ),
                    ),
                  ),
                  floatingActionButton:
                      FloatingAddCalendarButton(event: _event),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                );
            }
          });
    });
  }
}

class FloatingAddCalendarButton extends StatelessWidget {
  final Event event;
  const FloatingAddCalendarButton({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: SizeConfig.heightMultiplier! * 7.5,
        width: SizeConfig.maxWidth! * 0.75,
        decoration: BoxDecoration(
            color: Color.fromRGBO(233, 168, 3, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(35))),
        child: RawMaterialButton(
          onPressed: () {
            /* Router_.router.navigateTo(
                          context, '/addeventdevicecalendar');*/
            Navigator.of(context).push(TutorialOverlay(event));
          },
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/icons/icon_addtocalendar.png',
                    scale: SizeConfig.imageSizeMultiplier! * 0.7,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.widthMultiplier! * 1.5,
                ),
                Text(
                  'Adicionar ao calendário',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(fontSize: 2 * SizeConfig.textMultiplier!),
                )
              ]),
        ),
      );
    });
  }
}

class ColunaDetalhes extends StatelessWidget {
  const ColunaDetalhes({Key? key, required this.event}) : super(key: key);
  final Event event;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        //height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: constraints.maxWidth / 15,
                  right: constraints.maxWidth / 15),
              child: Container(
                  height: constraints.maxHeight * 0.06,
                  width: constraints.maxWidth,
                  child: ListView.builder(
                      //scrollDirection: Axis.,
                      physics: FixedExtentScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: event.categories!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var categoryname =
                            event.categories![index].category!.name!;
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 5, bottom: 5),
                          child: CategoryBasic(
                            name: categoryname,
                          ),
                        );
                      })),
            ),
          ],
        ),
      );
    });
  }
}

class IconFavoritoDetalhes extends StatefulWidget {
  const IconFavoritoDetalhes(
      {Key? key, required this.userPref, required this.event})
      : super(key: key);
  final UserPreferences userPref;
  final Event event;

  @override
  _IconFavoritoDetalhesState createState() => _IconFavoritoDetalhesState();
}

class _IconFavoritoDetalhesState extends State<IconFavoritoDetalhes> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/icons/icon_ellipse.png',
                scale: 2.5,
                color: Colors.white,
                width: 10 * SizeConfig.imageSizeMultiplier!,
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                top: 10,
                bottom: 0,
                child: widget.userPref.isFavorito(widget.event.id!)
                    ? Image.asset(
                        'assets/images/icons/icon_favorites.png',
                        scale: 2.2,
                        width: 10 * SizeConfig.imageSizeMultiplier!,
                      )
                    : Image.asset('assets/images/icons/icon_favorite.png',
                        scale: 2.2,
                        width: 10 * SizeConfig.imageSizeMultiplier!))
          ],
        ),
        onPressed: () {
          setState(() {
            widget.userPref.isFavorito(widget.event.id!)
                ? widget.userPref.removeFavorito(widget.event.id!)
                : widget.userPref.addFavorito(widget.event.id!);
          });
        });
  }
}

class Links extends StatelessWidget {
  final String text;
  const Links({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(text);
    String iconpath = getIconPath(uri);
    return Padding(
      padding: EdgeInsets.only(
          top: SizeConfig.heightMultiplier! * 0.5,
          bottom: SizeConfig.heightMultiplier! * 0.5),
      child: Container(
        //color: Colors.yellow,
        //height: SizeConfig.heightMultiplier! * 5,
        width: SizeConfig.maxWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: SizeConfig.heightMultiplier!),
              child: Image.asset(
                iconpath,
                height: SizeConfig.heightMultiplier! * 2.9,
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
