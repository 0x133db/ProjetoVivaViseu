import 'dart:convert';
import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivaviseu/allevents.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:vivaviseu/objects.dart';
import 'package:vivaviseu/searching.dart';
import 'package:vivaviseu/utils/category.dart';
import 'package:vivaviseu/utils/responsive.dart';
import 'package:vivaviseu/utils/style.dart';
import 'package:vivaviseu/utils/utils.dart';
//import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

//card swiper
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:flutter_card_swipper/widgets/flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_card_swipper/widgets/transformer_page_view/index_controller.dart';
import 'package:flutter_card_swipper/widgets/transformer_page_view/parallax.dart';
import 'package:flutter_card_swipper/widgets/transformer_page_view/transformer_page_view.dart';

import 'favorites.dart';
//

class HighlightedEvents extends StatefulWidget {
  HighlightedEvents({Key? key}) : super(key: key);

  @override
  HighlightedEventsState createState() => HighlightedEventsState();
}

class HighlightedEventsState extends State<HighlightedEvents> {
  List<Result>? eventosemdestaque; //lista de eventos em destaque
  late int numeroeventos; //numero de eventos em destaque
  int? numerocategorias; //numero de categorias

  late SharedPreferences userpreferences;
  late UserPreferences userPref;
  List<String>? eventosFavoritos = [];

  bool seeall = false;
  bool searching = false;
  bool teste = true;
  String searchtext = '';

  @override
  void initState() {
    print('[---------- Página Eventos em Destaque ----------]');
    super.initState();
    initSharedPreferences();
  }

  Future<List<Result>?> loadData() async {
    userPref = await UserPreferences();
    Uri eventosapiUrl =
        Uri.parse("http://vivaviseu.projectbox.pt/api/v1/highlighted_events");
    print('Link utilizado para Eventos em Destaque: $eventosapiUrl');
    var resposta = await http.get(eventosapiUrl);
    if (resposta.statusCode == 200) {
      Map<String, dynamic> body = json.decode(resposta.body);
      Welcome Data = Welcome.fromMap(body);
      print("Número de Eventos em Destaque: ${Data.result!.length}");
      int i;
      for (i = 0; i < Data.result!.length; i++) {
        print(
            'Evento: [ID:${Data.result![i].event!.id}] , Título: ${Data.result![i].event!.title} , Organizador: ${Data.result![i].event!.organizer!.name}');
      }
      numeroeventos = Data.getListEvents()!.length;
      eventosemdestaque = Data.result;
      return eventosemdestaque;
    }
  }

  Future<List<CategoryCategory>?> loadCategories() async {
    Uri categoriesapiUrl =
        Uri.parse("http://vivaviseu.projectbox.pt/api/v1/categories");
    print('Link utilizado para Categorias: $categoriesapiUrl');
    var resposta = await http.get(categoriesapiUrl);
    if (resposta.statusCode == 200) {
      Map<String, dynamic> body = json.decode(resposta.body);
      List<CategoryCategory> listaCategorias = [];
      numerocategorias = body['result'].length;
      for (int i = 0; i < body['result'].length; i++) {
        CategoryCategory category =
            CategoryCategory.fromMap(body['result'][i]['category']);
        print('${category.name}');
        listaCategorias.add(category);
      }
      return listaCategorias;
    }
  }

  void search(String content) async {
    Uri searchapiUrl = Uri.parse(
        "http://vivaviseu.projectbox.pt/api/v1/events?page=1&category=1&organizer=1&query=$content");
    print('Link utilizado para Eventos em Destaque: $searchapiUrl');
    var resposta = await http.get(searchapiUrl);
    if (resposta.statusCode == 200) {
      Map<String, dynamic> body = json.decode(resposta.body);
      Welcome Data = Welcome.fromMap(body);
      print("Número de resultados de pesquisa: ${Data.result!.length}");
      for (int i = 0; i < Data.result!.length; i++) {
        print(
            '#Evento: [ID:${Data.result![i].event!.id}] , Título: ${Data.result![i].event!.title} , Organizador: ${Data.result![i].event!.organizer!.name}');
      }
    }
  }

//Users Favorite Events Data Functions
//

  void initSharedPreferences() async {
    //SharedPreferences.setMockInitialValues(<String, dynamic>{'favoritos':[]});
    print('########### Loading Users Data... ###########');
    loadUserData();
    print('########### Users Data Loaded... $eventosFavoritos ###########');
  }

  loadUserData() async {
    userpreferences = await SharedPreferences.getInstance();
    if (userpreferences.getStringList('favoritos') == null) {
      return;
    }
    eventosFavoritos = userpreferences.getStringList('favoritos');
    print('Load User Data : $eventosFavoritos');
  }

  saveUserData() {
    userpreferences.setStringList('favoritos', eventosFavoritos!);
    loadUserData();
    print('Saved User Data : $eventosFavoritos');
  }

  addEventUserData(int? id) {
    print('Add Event User Data : $eventosFavoritos');
    if (eventosFavoritos!.contains(id.toString())) {
      print('After add Event User Data : $eventosFavoritos');
      removeEventUserData(id);
      return;
    }
    eventosFavoritos!.add(id.toString());
    saveUserData();
    print('After add Event User Data : $eventosFavoritos');
  }

  removeEventUserData(int? id) {
    print('Remove Event User Data : $eventosFavoritos');
    eventosFavoritos!.remove(id.toString());
    saveUserData();
    loadUserData();
    print('After Remove Event User Data : $eventosFavoritos');
  }

  Widget _getIconFavorite(int? id) {
    loadUserData();
    String string = id.toString();
    if (eventosFavoritos != null && eventosFavoritos!.contains(string)) {
      return Image.asset(
        'assets/images/icons/icon_favorites.png',
        scale: 3,
      );
    } else {
      return Image.asset(
        'assets/images/icons/icon_favorite.png',
        scale: 3,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 34, 42, 54),
              resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    6 * SizeConfig.widthMultiplier!,
                    2 * SizeConfig.heightMultiplier!,
                    6 * SizeConfig.widthMultiplier!,
                    0),
                child:/* Container(
                  height: 5.5 * SizeConfig.heightMultiplier!,
                  width: SizeConfig.maxWidth!,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Color.fromARGB(255, 47, 59, 76),
                  ),
                  child: */OutlineSearchBar(
                      hintText: 'Pesquisar',
                      searchButtonIconColor: Color.fromRGBO(153, 176, 210, 1),
                      searchButtonPosition: SearchButtonPosition.leading,
                      backgroundColor: Color.fromRGBO(47, 59, 77, 1),
                      borderColor: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      clearButtonColor: Colors.transparent,
                      textInputAction: TextInputAction.search,
                      maxLength: 25,
                      textStyle: AppTheme.TextStyleTheme.headline4!,
                      hintStyle: AppTheme.TextStyleTheme.headline4!.copyWith(color: Color.fromRGBO(152, 176, 210, 1)),
                      cursorColor: Color.fromRGBO(233, 168, 3, 1),
                    onSearchButtonPressed: (value) {
                      print('Vou mandar isto $value');
                      Router_.router.navigateTo(
                          context, '/listagemgeralpesquisa?text=$value');
                      
                    },
                  ),
                //),
              ),
              //Barra de Categorias
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      6 * SizeConfig.widthMultiplier!,
                      2.2 * SizeConfig.heightMultiplier!,
                      6 * SizeConfig.widthMultiplier!,
                      0),
                  child: SingleChildScrollView(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 4 * SizeConfig.heightMultiplier!,
                            child: FutureBuilder(
                                future: loadCategories(),
                                builder:
                                    // ignore: missing_return
                                    (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      return Container(
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    case ConnectionState.waiting:
                                      return Container(
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    case ConnectionState.done:
                                      return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: numerocategorias,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var categoryname =
                                                snapshot.data[index].name;
                                            var categoryid =
                                                snapshot.data[index].id;
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: CategoryTabSimple(
                                                categoryname: categoryname,
                                                id: categoryid,
                                              ),
                                            );
                                          });
                                    case ConnectionState.active:
                                      return Container(
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                  }
                                }),
                          ),
                        ),
                      ],
                    ),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    6 * SizeConfig.widthMultiplier!,
                    2.5 * SizeConfig.heightMultiplier!,
                    6 * SizeConfig.widthMultiplier!,
                    0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Destaques',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    GestureDetector(
                      onTap: () {
                        Router_.router.navigateTo(context, '/listagemgeral');
                      },
                      child: Text(
                        'ver todos',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: SizeConfig.heightMultiplier! * 3.3),
                  child: Container(
                    //height: 54 * SizeConfig.heightMultiplier!,
                    //color: Colors.yellow,
                    height: SizeConfig.maxHeight! * 0.65,
                    width: SizeConfig.maxWidth,
                    child: FutureBuilder(
                        future: loadData(),
                        // ignore: missing_return
                        builder:
                            // ignore: missing_return
                            (BuildContext context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Container(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            case ConnectionState.done:
                              return Swiper(
                                  itemCount: numeroeventos,
                                  itemWidth: SizeConfig.maxWidth! * 0.7,
                                  itemHeight: SizeConfig.maxHeight! * 0.55,
                                  scrollDirection: Axis.horizontal,
                                  layout: SwiperLayout.STACK,
                                  itemBuilder:
                                      (BuildContext Context, int index) {
                                    var event = snapshot.data[index].event;
                                    var eventid = snapshot.data[index].event.id;
                                    var title =
                                        snapshot.data[index].event.title;
                                    var location =
                                        snapshot.data[index].event.location;
                                    var startdate =
                                        snapshot.data[index].event.startDate;
                                    String formattedDate = formatDate(
                                            event.dates![0].date!.eventDate!,
                                            [dd]) +
                                        ' de ' +
                                        formatDate(
                                            event.dates![0].date!.eventDate!,
                                            [MM],
                                            locale: PortugueseDateLocale()) +
                                        ' ' +
                                        formatDate(
                                            event.dates![0].date!.eventDate!,
                                            [yyyy]);
                                    String timeevent =
                                        '${formatDate(event.dates![0].date!.timeStart!, [
                                              HH
                                            ])}' +
                                            'h' +
                                            '${formatDate(event.dates![0].date!.timeStart!, [
                                              nn
                                            ])}';
                                    var image =
                                        'http://${snapshot.data[index].event.images[0].image.original}';
                                    List<String?> listcateg = [];
                                    int numcateg = event.categories.length;
                                    for (var i = 0; i < numcateg; i++) {
                                      listcateg.add(
                                          event.categories[i].category.name);
                                    }
                                    return Container(
                                      child: Card(
                                        color: Colors.grey[900],
                                        elevation: 5,
                                        shadowColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12))),
                                        child: Stack(
                                          children: [
                                            ShaderMask(
                                              shaderCallback: (rect) {
                                                return LinearGradient(
                                                    begin: Alignment(0, -0.1),
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 34, 42, 54),
                                                      Colors.transparent
                                                    ]).createShader(
                                                    Rect.fromLTRB(
                                                        0,
                                                        0,
                                                        rect.width,
                                                        rect.height));
                                              },
                                              blendMode: BlendMode.dstIn,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12)),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                        image,
                                                      ),
                                                      fit: BoxFit.fill),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 2 *
                                                        SizeConfig
                                                            .widthMultiplier!,
                                                    top: 2 *
                                                        SizeConfig
                                                            .widthMultiplier!),
                                                child: Container(
                                                  //color: Colors.yellow,
                                                  height: 3 *
                                                      SizeConfig
                                                          .heightMultiplier!,
                                                  width: 3 *
                                                      SizeConfig
                                                          .heightMultiplier!,
                                                  child: Stack(
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
                                                          width: 10 *
                                                              SizeConfig
                                                                  .imageSizeMultiplier!,
                                                        ),
                                                      ),
                                                      Positioned(
                                                          left: 0,
                                                          right: 0,
                                                          top: 10,
                                                          bottom: 0,
                                                          child: userPref
                                                                  .isFavorito(
                                                                      event.id!)
                                                              ? Image.asset(
                                                                  'assets/images/icons/icon_favorites.png',
                                                                  scale: 2.2,
                                                                  width: 10 *
                                                                      SizeConfig
                                                                          .imageSizeMultiplier!,
                                                                )
                                                              : Image.asset(
                                                                  'assets/images/icons/icon_favorite.png',
                                                                  scale: 2.2,
                                                                  width: 10 *
                                                                      SizeConfig
                                                                          .imageSizeMultiplier!))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: SizeConfig
                                                            .heightMultiplier! *
                                                        2,
                                                    bottom: SizeConfig
                                                            .heightMultiplier! *
                                                        1.5),
                                                child: Container(
                                                  height: SizeConfig
                                                          .heightMultiplier! *
                                                      10,
                                                  //color: Colors.blue,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      //Desenho de Categoria
                                                      Expanded(
                                                        child: Padding(
                                                          //padding: const EdgeInsets.fromLTRB(10, 10, 10, 7),
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          child: Row(
                                                            children: [
                                                              CategoryWidget(
                                                                  context,
                                                                  categorytext:
                                                                      listcateg[
                                                                          0]),
                                                              SizedBox(
                                                                width: SizeConfig
                                                                        .widthMultiplier! *
                                                                    1.5,
                                                              ),
                                                              listcateg.length >
                                                                      1
                                                                  ? CategoryplusWidget(
                                                                      context,
                                                                      categorytext:
                                                                          '+1')
                                                                  : Container(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 6,
                                                      ),
                                                      Text(
                                                        title,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline2!
                                                            .copyWith(
                                                                fontSize: 1.5 *
                                                                    SizeConfig
                                                                        .textMultiplier!,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/icons/icon_eventdetailscalendar.png',
                                                            scale: 0.35 *
                                                                SizeConfig
                                                                    .heightMultiplier!,
                                                          ),
                                                          SizedBox(
                                                            width: 1.4 *
                                                                SizeConfig
                                                                    .widthMultiplier!,
                                                          ),
                                                          Text(
                                                            formattedDate,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption,
                                                          ),
                                                          SizedBox(
                                                            width: 3 *
                                                                SizeConfig
                                                                    .widthMultiplier!,
                                                          ),
                                                          Image.asset(
                                                            'assets/images/icons/icon_eventdetailswatch.png',
                                                            scale: 0.35 *
                                                                SizeConfig
                                                                    .heightMultiplier!,
                                                          ),
                                                          SizedBox(
                                                            width: 2 *
                                                                SizeConfig
                                                                    .widthMultiplier!,
                                                          ),
                                                          Text(
                                                            timeevent,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/icons/icon_eventdetailslocation.png',
                                                            scale: 0.35 *
                                                                SizeConfig
                                                                    .heightMultiplier!,
                                                          ),
                                                          SizedBox(
                                                            width: 2 *
                                                                SizeConfig
                                                                    .widthMultiplier!,
                                                          ),
                                                          Text(
                                                            location,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            /*CarouselSlider.builder(
                                itemCount: numeroeventos,
                                itemBuilder:
                                    (BuildContext context, int index, int why) {
                                  // ignore: unused_local_variable
                                  var event = snapshot.data[index].event;
                                  var eventid = snapshot.data[index].event.id;
                                  var title = snapshot.data[index].event.title;
                                  var location =
                                      snapshot.data[index].event.location;
                                  var startdate =
                                      snapshot.data[index].event.startDate;
                                  var formattedDate =
                                      "${startdate.day}-${startdate.month}-${startdate.year}";
                                  var timeevent = snapshot
                                      .data[index].event.dates[0].date.timeStart;
                                  var time =
                                      "${timeevent.hour}h${timeevent.minute}";
                                  var image =
                                      'http://${snapshot.data[index].event.images[0].image.original}';
                                  var category = snapshot.data[index].event
                                      .categories[0].category.name;
                                  return GestureDetector(
                                    onTap: () {
                                      int fav;
                                      if (eventosFavoritos!
                                          .contains(eventid.toString())) {
                                        fav = 0;
                                      } else {
                                        fav = 1;
                                      }
                                      Router_.router.navigateTo(context,
                                          '/eventdetails?eventoid=$eventid');
                                    },
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      alignment: Alignment.center,
                                      child: Card(
                                        elevation: 5,
                                        shadowColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        child: Container(
                                    height: SizeConfig.maxHeight! *0.625,
                                    width: SizeConfig.maxWidth!,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            color: Colors.black,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  image,
                                                ),
                                                fit: BoxFit.fill),
                                          ),
                                          child: Column(
                                            //coluna de widgets sobre a imagem
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/icons/icon_ellipse.png',
                                                          scale: 4,
                                                        ),
                                                        IconButton(
                                                          icon:
                                                              /*Image.asset(
                                                          'assets/images/icons/icon_favorites.png',
                                                          scale: 2,
                                                        ),*/
                                                              _getIconFavorite(
                                                                  eventid),
                                                          onPressed: () {
                                                            setState(() {
                                                              //addeventtofavorites(event);
                                                              addEventUserData(
                                                                  eventid);
                                                            });
                                                          },
                                                        ),
                                                      ]),
                                                ],
                                              ),
                                              SizedBox(height: 300),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 10, 15, 10),
                                                child: Container(
                                                  width: 200,
                                                  height: 80,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      //Desenho de Categoria
                                                      Container(
                                                        width: 85,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromRGBO(
                                                                    233,
                                                                    168,
                                                                    3,
                                                                    1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child: Center(
                                                          child: Text(
                                                            category,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 11),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 6,
                                                      ),
                                                      Text(
                                                        title,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/icons/icon_eventdetailscalendar.png',
                                                            scale: 2,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            formattedDate,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Image.asset(
                                                            'assets/images/icons/icon_eventdetailswatch.png',
                                                            scale: 2,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            time,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/icons/icon_eventdetailslocation.png',
                                                            scale: 2,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            location,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                  height: SizeConfig.maxHeight!*0.6,
                                  //aspectRatio: 1,
                                  pageSnapping: true,
                                  viewportFraction: 0.75,
                                  enlargeCenterPage: true,
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.scale,
                                  autoPlay: true,
                                  autoPlayCurve: Curves.easeInOut,
                                  enableInfiniteScroll: false,
                                  disableCenter: true,
                                ),
                              );*/
                            case ConnectionState.waiting:
                              return Container(
                                height: 400,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            case ConnectionState.active:
                              return Container(
                                height: 400,
                                child: Center(
                                  child: Text('Active'),
                                ),
                              );
                          }
                        }),
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}
