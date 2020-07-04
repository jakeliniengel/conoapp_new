import 'package:conoappnew/pages/splash_page.dart';
import 'package:conoappnew/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:internationalization/internationalization.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';

var _color;
Map<int, Color> _colorMap = {
  50: Color.fromRGBO(147, 205, 72, .1),
  100: Color.fromRGBO(147, 205, 72, .2),
  200: Color.fromRGBO(147, 205, 72, .3),
  300: Color.fromRGBO(147, 205, 72, .4),
  400: Color.fromRGBO(147, 205, 72, .5),
  500: Color.fromRGBO(147, 205, 72, .6),
  600: Color.fromRGBO(147, 205, 72, .7),
  700: Color.fromRGBO(147, 205, 72, .8),
  800: Color.fromRGBO(147, 205, 72, .9),
  900: Color.fromRGBO(147, 205, 72, 1),
};
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Internationalization.loadConfigurations();
  loadCnfiguration();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(CoronaApp());

  }
  );
}
void loadCnfiguration() async {
  _color = await Settings().getString(
    'opc_primary_color',
    '0xfffc0fc0',
  );
}

class CoronaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoronaApp',
      theme: ThemeData(
        primaryColor: Color(int.parse(_color))

      ),
      home: SplashPage(),
      routes: routes,
      supportedLocales: suportedLocales,
      localizationsDelegates: [
        Internationalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }
}
