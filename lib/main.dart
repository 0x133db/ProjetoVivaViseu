import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:vivaviseu/config/routes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:device_preview/device_preview.dart';
import 'package:vivaviseu/utils/responsive.dart';
import 'package:vivaviseu/utils/style.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((_) => runApp(App()));
  
  ///Ver noutros dispositivos
  //runApp(DevicePreview(enabled: true ,builder: (context){return App();}));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  _AppState(){
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      final FluroRouter router = FluroRouter();
      Routes.configureRoutes(router);
      Router_.router = router; 
  }

  @override
  Widget build(BuildContext context) {
    var app = LayoutBuilder(
      builder: (context,constraints){
        SizeConfig().init(constraints);
        return MaterialApp(
      title: 'Viva Viseu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      onGenerateRoute: Router_.router.generator,
      
    );
    }
    );
    return app;
  }
}