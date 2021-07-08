import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivaviseu/objects.dart';
import 'package:quiver/async.dart';
import 'package:quiver/cache.dart';
import 'package:quiver/check.dart';
import 'package:quiver/collection.dart';
import 'package:quiver/core.dart';
import 'package:quiver/iterables.dart';
import 'package:quiver/pattern.dart';
import 'package:quiver/strings.dart';
import 'package:quiver/testing/async.dart';
import 'package:quiver/testing/equality.dart';
import 'package:quiver/testing/src/async/fake_async.dart';
import 'package:quiver/testing/src/equality/equality.dart';
import 'package:quiver/testing/src/time/time.dart';
import 'package:quiver/testing/time.dart';
import 'package:quiver/time.dart';

//SharedPreferences manager class

class UserPreferences {
  SharedPreferences? userpref;
  List<String> favoritos = [];

  UserPreferences() {
    initUserPreferences();
  }

  initUserPreferences() async {
    userpref = await SharedPreferences.getInstance();
    if (userpref!.getStringList('favoritos') == null) {
      userpref!.setStringList('favoritos', []);
    }
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

//General use functions

 orderListEvents(List<Event?> list) {
  int size = list.length;
  for (int i = 0; i < size - 1; i++) {
    for (int j = 0; j < size - 1; j++) {
      if (list[j]!.startDate!.isAfter(list[j + 1]!.startDate!)) {
        Event aux = list[j]!;
        list[j] = list[j + 1];
        list[j + 1] = aux;
      }
    }
  }
}

bool checkenddatebeforestartdate(
    int startyear,
    int startmonth,
    int startday,
    int starthour,
    int startminute,
    int endyear,
    int endmonth,
    int endday,
    int endhour,
    int endminute) {
  if (startyear == endyear && startmonth == endmonth && startday == endday) {
    if (endminute <= startminute && endhour < starthour) {
      print(
          'DataHora Fim : $endyear $endmonth $endday $endhour $endminute , antes de DataHora Inicio : $startyear $startmonth $startday $starthour $startminute');
      return true;
    }
  }
  return false;
}

int getReminderMinutes(
    String alerttext, List<String> alertas, int startyear, int startmonth) {
  int minutes;
  for (int i = 0; i < alertas.length; i++) {
    if (alerttext == alertas[i]) {
      if (i == 0) {
        return minutes = 0;
      }
      if (i == 1) {
        print('Alertas 3 -> minutos 60');
        return minutes = 60;
      }
      if (i == 2) {
        return minutes = 60 * 24;
      }
      if (i == 3) {
        return minutes = 60 * 24 * 7;
      }
      if (i == 4) {
        int diasmes = daysInMonth(startyear, startmonth);
        return minutes = 60 * 24 * diasmes;
      }
    }
  }
  return minutes = 0;
}

String getIconPath(Uri uri) {
  String instagram = 'assets/images/icons/instagram.png';
  String facebook = 'assets/images/icons/facebook.png';
  String twitter = 'assets/images/icons/twitter.png';
  String youtube = 'assets/images/icons/youtube.png';
  String link = 'assets/images/icons/link.png';

  var host = uri.host;
  if (host == 'www.instagram.com') {
    return instagram;
  }
  if (host == 'www.facebook.com') {
    return facebook;
  }
  if (host == 'www.twitter.com') {
    return twitter;
  }
  if (host == 'www.youtube.com') {
    return youtube;
  }
  return link;
}
