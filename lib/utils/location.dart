import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/tzdata.dart';

class AppLocation{
  tz.Location? _applocation;

  AppLocation(){
    tzdata.initializeTimeZones();
    //this._applocation = tz.getLocation('Europe/Lisbon');
    Map<String,tz.Location> locations = tz.timeZoneDatabase.locations;
    String local = 'Europe/Lisbon';
    this._applocation = locations[local];
    print(this._applocation);
  }

  tz.Location? getLocation(){
    return this._applocation;
  }

}