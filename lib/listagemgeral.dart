import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:vivaviseu/calendar.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:vivaviseu/objects.dart';
import 'package:vivaviseu/Favorites.dart';
import 'package:vivaviseu/utils/category.dart';
import 'package:http/http.dart' as http;
import 'package:group_button/group_button.dart';
import 'package:vivaviseu/utils/containers.dart';
import 'package:vivaviseu/utils/eventscontainers.dart';
import 'package:vivaviseu/utils/responsive.dart';
import 'package:vivaviseu/utils/style.dart';
import 'package:vivaviseu/utils/utils.dart';
import 'package:sizer/sizer.dart';

class ListagemGeral extends StatefulWidget {
  const ListagemGeral({
    Key? key,
    this.categoryid,
    this.searchtext,
  }) : super(key: key);
  final int? categoryid;
  final String? searchtext;
  @override
  _ListagemGeralState createState() => _ListagemGeralState();
}

class _ListagemGeralState extends State<ListagemGeral> {
  final GroupButtons Buttons = GroupButtons();
  int? numerocategorias;
  List<CategoryCategory?> categorylist = [];
  final ValueNotifier<int> categorychange = ValueNotifier(0);
  late int inhcategoryid;
  late String selectedone;
  String tobsearched = '';
  bool categorysearch = false;
  bool searchsearch = false;

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
        listaCategorias.add(category);
      }
      categorylist = listaCategorias;
      return listaCategorias;
    }
  }

  @override
  void initState() {
    print('[---------- Página Listagem Geral ----------]');
    print('-------------${widget.searchtext}--------------');
    super.initState();
    if (widget.categoryid != null) {
      inhcategoryid = widget.categoryid!;
      print('Listar categoria $inhcategoryid');
      Buttons.setSelected(inhcategoryid);
      //categorychange.value = Buttons.getSelected();
      parentchange(inhcategoryid);
    }
    if (widget.searchtext != null) {
      print('Listar Pesquisa ${widget.searchtext}');
      tobsearched = widget.searchtext!;
      categorysearch = false;
      searchsearch = true;
    }
  }

  void parentchange(int id) {
    print('categorychange = ${categorychange.value} e categoryid = $id ');
    if (categorychange.value == id) {
      categorysearch = false;
      searchsearch = false;
      print('Tenho que mostrar todos!');
      setState(() {
        categorychange.value = 999;
      });
      return;
    } else{
      setState(() {
        categorychange.value = id;
        categorysearch = true;
        searchsearch = false;
        print('Tenho que mostrar apenas da categoria $id');
      });
      return;
    }
  }

  void submitSearch(String text) {
    categorysearch = false;
    searchsearch = true;
    tobsearched = text;
    categorychange.value = 999;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 42, 54),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              6 * SizeConfig.widthMultiplier!,
              1.4 * SizeConfig.heightMultiplier!,
              6 * SizeConfig.widthMultiplier!,
              0),
          child: Container(
            height: SizeConfig.maxHeight!,
            width: SizeConfig.maxWidth!,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(bottom: SizeConfig.heightMultiplier! * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          icon: Image.asset(
                            'assets/images/icons/icon_backarrow.png',
                            scale: 2,
                          ),
                          onPressed: () {
                            Router_.router.pop(context);
                          }),
                      Text(
                        'Todos os Eventos',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 1 * SizeConfig.heightMultiplier!,
                      bottom: 1 * SizeConfig.heightMultiplier!),
                  child: Container(
                    child: OutlineSearchBar(
                      hintText: tobsearched.isEmpty ? 'Pesquisar' : tobsearched,
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
                        submitSearch(value);
                      },
                      onTypingFinished: (value) => print('Pesquisa ? $value'),
                      onTap: (){
                        setState(() {
                                                               Buttons.removeSelected();
                                                                    searchsearch = false;
                                  categorysearch = false;
                                  tobsearched = 'Pesquisar';                     
                                                });
                                  //categorychange.value = Buttons.getSelected();
                      },
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        0,
                        SizeConfig.heightMultiplier! * 1.2,
                        0,
                        SizeConfig.heightMultiplier! * 2),
                    child: WidgetListaCategorias(
                      selectedCategory: (int) {
                        parentchange(int);
                      },
                      buttons: Buttons,
                      alreadyselected: categorychange.value,
                    )),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier!),
                    child: ValueListenableBuilder(
                      valueListenable: categorychange,
                      builder:
                          (BuildContext context, int value, Widget? child) {
                        return Container(
                          child: searchsearch == true
                              ? Listagemporpesquisa(
                                  text: tobsearched,
                                )
                              : categorysearch == true
                                  ? Listagemporcategoria(
                                      id: categorychange.value,
                                    )
                                  : Listagemtodoseventos(),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class WidgetListaCategorias extends StatefulWidget {
  const WidgetListaCategorias(
      {Key? key, required this.selectedCategory, this.alreadyselected, required this.buttons})
      : super(key: key);
  final Function(int) selectedCategory;
  final int? alreadyselected;
  final GroupButtons buttons;

  @override
  _WidgetListaCategoriasState createState() => _WidgetListaCategoriasState();
}

class _WidgetListaCategoriasState extends State<WidgetListaCategorias> {
  int numerocategorias = 0;
  int selectedcategory = 0;
  final ValueNotifier<int> teste = ValueNotifier(0);
  //late final GroupButtons Buttons;
  //final ValueNotifier<bool> redrawListaCategorias = ValueNotifier(false);
  List<CategoryCategory> categorylist = [];

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
      categorylist = listaCategorias;
      return listaCategorias;
    }
  }

  void iniState() {
    super.initState();
    if(widget.alreadyselected != null){
      if(selectedcategory != widget.buttons.getSelected())
      selectedcategory = widget.alreadyselected!;
    }
  }

  /*void listController(int categoryid) {
    //teste
    //selectedcategory = categoryid;
    //

    // if (widget.buttons.getSelected() == selectedcategory) {
    if (widget.buttons.getSelected() == categoryid) {
      setState(() {
        print('Des selecionei categoria $categoryid!');
        widget.buttons.removeSelected();
        selectedcategory = widget.buttons.getSelected();
        widget.selectedCategory(categoryid);
        return;
      });
    } else {
      setState(() {
        print('Selecionei categoria $categoryid!');
        selectedcategory = widget.buttons.getSelected();
        //widget.buttons.removeSelected();
        widget.selectedCategory(selectedcategory);
        return;
      });
    }
  }*/

    void listController(int categoryid) {
    //teste
    //selectedcategory = categoryid;
    //

    if(categoryid != 999){
      setState(() {
              selectedcategory = categoryid;
              widget.selectedCategory(selectedcategory);
            });
            return;
    }else{
      setState(() {
              selectedcategory = categoryid;
              widget.selectedCategory(selectedcategory);
            });
    }

    // if (widget.buttons.getSelected() == selectedcategory) {
    if (widget.buttons.getSelected() == categoryid) {
      setState(() {
        print('Des selecionei categoria $categoryid!');
        widget.buttons.removeSelected();
        selectedcategory = widget.buttons.getSelected();
        widget.selectedCategory(categoryid);
        return;
      });
    } else {
      setState(() {
        print('Selecionei categoria $categoryid!');
        selectedcategory = widget.buttons.getSelected();
        //widget.buttons.removeSelected();
        widget.selectedCategory(selectedcategory);
        return;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Expanded(
            child: Container(
                height: 4 * SizeConfig.heightMultiplier!,
                child: categorylist.isEmpty == true
                    ? FutureBuilder(
                        future: loadCategories(),
                        builder:
                            // ignore: missing_return
                            (BuildContext context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return ContainerNetworkError(); /*Container(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );*/
                            case ConnectionState.waiting:
                              return Container(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            case ConnectionState.done:
                              print('FutureBuilder');
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: numerocategorias,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var categoryname =
                                        snapshot.data[index].name;
                                    var categoryid = snapshot.data[index].id;
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          right: 2.2 *
                                              SizeConfig.widthMultiplier!),
                                      child: categoryid == selectedcategory
                                          //categoryid == widget.alreadyselected
                                          ? CategoryTab(
                                              categoryname: categoryname,
                                              id: categoryid,
                                              //preselected: true,
                                              selected: listController,
                                              buttons: widget.buttons,
                                            )
                                          : CategoryTab(
                                              categoryname: categoryname,
                                              id: categoryid,
                                              //preselected: false,
                                              selected: listController,
                                              buttons: widget.buttons),
                                    );
                                  });
                            case ConnectionState.active:
                              return Container(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                          }
                        })
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: numerocategorias,
                        itemBuilder: (BuildContext context, int index) {
                          var categoryname = categorylist[index].name;
                          var categoryid = categorylist[index].id;
                          return Padding(
                              padding: EdgeInsets.only(
                                  right: 2.2 * SizeConfig.widthMultiplier!),
                              child: CategoryTab(
                                categoryname: categoryname!,
                                id: categoryid,
                                preselected: selectedcategory == categoryid
                                    ? true
                                    : false,
                                selected: listController,
                                buttons: widget.buttons,
                              ));
                        })),
          ),
        ],
      ),
    );
  }
}

class Listagemporcategoria extends StatefulWidget {
  final int? id;
  const Listagemporcategoria({Key? key, this.id}) : super(key: key);

  @override
  _ListagemporcategoriaState createState() => _ListagemporcategoriaState();
}

class _ListagemporcategoriaState extends State<Listagemporcategoria> {
  int? numeroeventos;
  List<Result> eventosalistar = []; //lista de eventos a listar
  late UserPreferences up;

  Future<List<Result>?> loadData() async {
    if(eventosalistar.isNotEmpty){eventosalistar.clear();}
    up = await UserPreferences();
    Uri categoriasapiUrl = Uri.parse(
        "http://vivaviseu.projectbox.pt/api/v1/events?category=${widget.id}");
    print('Link utilizado para Pesquisa Categoria : $categoriasapiUrl');
    var resposta = await http.get(categoriasapiUrl);
    if (resposta.statusCode == 200) {
      Map<String, dynamic> body = json.decode(resposta.body);
      Welcome Data = Welcome.fromMap(body);
      numeroeventos = Data.getListEvents()!.length;
      if(Data.result != null){
      eventosalistar = Data.result!;
      }
      return eventosalistar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Container(
          height: SizeConfig.maxHeight,
          width: SizeConfig.maxWidth,
          child: FutureBuilder(
            future: loadData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Container(
                    child: Center(child: ContainerNetworkError()),
                  );
                case ConnectionState.done:
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      //shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: numeroeventos,
                      itemBuilder: (BuildContext context, int index) {
                        Event event = snapshot.data[index].event;
                        List<String?> listcateg = [];
                        int numcateg = event.categories!.length;
                        for (var i = 0; i < numcateg; i++) {
                          listcateg.add(event.categories![i].category!.name);
                        }
                        bool imagebool = true;
                        index == numeroeventos! - 1
                            ? imagebool = false
                            : imagebool = true;
                        return GestureDetector(
                          onTap: () {
                            Router_.router.navigateTo(
                                context, '/eventdetails?eventoid=${event.id}');
                          },
                          child: WidgetContainerEventos(
                            evento: event,
                            userPreferences: up,
                            listacategorias: listcateg,
                            imagebool: imagebool,
                          ),
                        );
                      });
                case ConnectionState.waiting:
                  return Container(
                    child: Center(child: CircularProgressIndicator()),
                  );
                case ConnectionState.active:
                  return Container(
                      child: Center(child: CircularProgressIndicator()));
              }
            },
          ),
        ),
      ),
    );
  }
}

class Listagemtodoseventos extends StatefulWidget {
  const Listagemtodoseventos({Key? key}) : super(key: key);

  @override
  _ListagemtodoseventosState createState() => _ListagemtodoseventosState();
}

class _ListagemtodoseventosState extends State<Listagemtodoseventos> {
  int? numeroeventos;
  List<Event> eventosalistar = []; //lista de eventos a listar
  late UserPreferences up;

  Future<List<Event>?> loadData() async {
    eventosalistar.clear();
    up = await UserPreferences();
    Uri eventosapiUrl =
        Uri.parse("http://vivaviseu.projectbox.pt/api/v1/events/");
    print('Link utilizado para Eventos : $eventosapiUrl');
    var resposta = await http.get(eventosapiUrl);
    if (resposta.statusCode == 200) {
      Map<String, dynamic> body = json.decode(resposta.body);
      Welcome Data = Welcome.fromMap(body);
      int i;
      for (i = 0; i < Data.result!.length; i++) {
        eventosalistar.add(Data.result![i].event!);
      }
      numeroeventos = Data.getListEvents()!.length;
      orderListEvents(eventosalistar);
      return eventosalistar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.maxHeight,
      width: SizeConfig.maxWidth,
      child: FutureBuilder(
        future: loadData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            case ConnectionState.done:
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  //shrinkWrap: true,
                  //physics: ClampingScrollPhysics(),
                  itemCount: numeroeventos,
                  itemBuilder: (BuildContext context, int index) {
                    Event event = snapshot.data[index];
                    List<String?> listcateg = [];
                    int numcateg = event.categories!.length;
                    for (var i = 0; i < numcateg; i++) {
                      listcateg.add(event.categories![i].category!.name);
                    }
                    bool imagebool = true;
                    index == numeroeventos! - 1
                        ? imagebool = false
                        : imagebool = true;
                    return GestureDetector(
                      onTap: () {
                        Router_.router.navigateTo(
                            context, '/eventdetails?eventoid=${event.id}');
                      },
                      child: WidgetContainerEventos(
                        evento: event,
                        userPreferences: up,
                        listacategorias: listcateg,
                        imagebool: imagebool,
                      ),
                    );
                  });
            case ConnectionState.waiting:
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            case ConnectionState.active:
              return Container(
                  child: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }
}

class Listagemporpesquisa extends StatefulWidget {
  const Listagemporpesquisa({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  _ListagemporpesquisaState createState() => _ListagemporpesquisaState();
}

class _ListagemporpesquisaState extends State<Listagemporpesquisa> {
  int numeroeventos = 0;
  List<Event> eventosalistar = [];
  late UserPreferences up;

  Future<List<Event>?> search(String content) async {
    up = await UserPreferences();
    Uri searchapiUrl = Uri.parse(
        "http://vivaviseu.projectbox.pt/api/v1/events?page=1&category=1&organizer=1&query=$content");
    print('Link utilizado para Pesquisa de Eventos: $searchapiUrl');
    var resposta = await http.get(searchapiUrl);
    if (resposta.statusCode == 200) {
      Map<String, dynamic> body = json.decode(resposta.body);
      Welcome Data = Welcome.fromMap(body);
      print("Número de resultados de pesquisa: ${Data.result!.length}");
      numeroeventos = Data.result!.length;
      for (int i = 0; i < Data.result!.length; i++) {
        eventosalistar.add(Data.result![i].event!);
        print(
            '#Evento: [ID:${Data.result![i].event!.id}] , Título: ${Data.result![i].event!.title} , Organizador: ${Data.result![i].event!.organizer!.name}');
      }
    }
    orderListEvents(eventosalistar);
    return eventosalistar;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Container(
          height: SizeConfig.maxHeight,
          width: SizeConfig.maxWidth,
          child: FutureBuilder(
            future: search(widget.text),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Container(
                    child: Center(child: CircularProgressIndicator()),
                  );
                case ConnectionState.done:
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      //shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: numeroeventos,
                      itemBuilder: (BuildContext context, int index) {
                        Event event = snapshot.data[index];
                        String categoriatext =
                            snapshot.data[index].categories[0].category.name;
                        List<String?> listcateg = [];
                        int numcateg = snapshot.data[index].categories.length;
                        for (var i = 0; i < numcateg; i++) {
                          listcateg.add(event.categories![i].category!.name);
                        }
                        bool imagebool = true;
                        index == numeroeventos - 1
                            ? imagebool = false
                            : imagebool = true;
                        return GestureDetector(
                          onTap: () {
                            Router_.router.navigateTo(
                                context, '/eventdetails?eventoid=${event.id}');
                          },
                          child: WidgetContainerEventos(
                            evento: event,
                            userPreferences: up,
                            listacategorias: listcateg,
                            imagebool: imagebool,
                          ),
                        );
                      });
                case ConnectionState.waiting:
                  return Container(
                    child: Center(child: CircularProgressIndicator()),
                  );
                case ConnectionState.active:
                  return Container(
                      child: Center(child: CircularProgressIndicator()));
              }
            },
          ),
        ),
      ),
    );
  }
}
