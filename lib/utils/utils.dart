import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  SharedPreferences? userpref;
  List<String> favoritos = [];

  UserPreferences() {
    initUserPreferences();
  }

  initUserPreferences() async {
    this.userpref = await SharedPreferences.getInstance();
    favoritos = userpref!.getStringList('favoritos')!;
    print('User Preferences Class Favorites : $favoritos');
  }

  List<String> getFavoritos() {
    return this.favoritos;
  }

  setFavoritos() {
    userpref!.setStringList('favoritos', favoritos);
  }

  addFavorito(int _id) {
    print('User Preferences Class Favorites : A adicionar evento $_id...');
    String stringid = _id.toString();
    if (favoritos.contains(stringid) == false) {
      favoritos.add(stringid);
      setFavoritos();
      print('User Preferences Class Favorites : $favoritos');
      print('User Preferences Class Favorites : Evento $_id adicionado ...');
    }
  }

  removeFavorito(int _id) {
    print('User Preferences Class Favorites : A remover evento $_id...');
    String stringid = _id.toString();
    if (favoritos.contains(stringid)) {
      favoritos.remove(stringid);
      setFavoritos();
      print('User Preferences Class Favorites : $favoritos');
      print('User Preferences Class Favorites : Evento $_id removido ...');
    }
  }

  bool isFavorito(int _id) {
    String stringid = _id.toString();
    return favoritos.contains(stringid);
  }
}
