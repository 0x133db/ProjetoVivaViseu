import 'dart:convert';

import 'package:vivaviseu/objects.dart';
import 'package:http/http.dart' as http;

//Not finished

Future<List<CategoryCategory>?> loadCategories() async {
  Uri categoriesapiUrl =
      Uri.parse("http://vivaviseu.projectbox.pt/api/v1/categories");
  print('Link utilizado para Categorias: $categoriesapiUrl');
  var resposta = await http.get(categoriesapiUrl);
  if (resposta.statusCode == 200) {
    Map<String, dynamic> body = json.decode(resposta.body);
    List<CategoryCategory> listaCategorias = [];
    for (int i = 0; i < body['result'].length; i++) {
      CategoryCategory category =
          CategoryCategory.fromMap(body['result'][i]['category']);
      print('${category.name}');
      listaCategorias.add(category);
    }
    return listaCategorias;
  }
}

Future<int?> getnumerocategorias() async {
  int numero = 0;
  Uri categoriesapiUrl =
      Uri.parse("http://vivaviseu.projectbox.pt/api/v1/categories");
  var resposta = await http.get(categoriesapiUrl);
  if (resposta.statusCode == 200) {
    Map<String, dynamic> body = json.decode(resposta.body);
    for (int i = 0; i < body['result'].length; i++) {
      numero++;
    }
    return numero;
  }
}
