import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/core/routes.dart';
import 'package:flutter_clean_architecture/core/styles/colors.dart';
import 'package:flutter_clean_architecture/core/styles/text_styles.dart';
import 'injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MyApp(),
    );
  });
}

class MyApp extends StatelessWidget {
  final _router = AppRouter();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TMDB Movie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: kColorLightScheme,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: kTextThemeLight,
      ),
      darkTheme: ThemeData(
        colorScheme: kColorDarkScheme,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xff25262E),
        textTheme: kTextThemeDark,
      ),
      initialRoute: "/use_selector",
      onGenerateRoute: _router.onGenerateRoute,
    );
  }
}
