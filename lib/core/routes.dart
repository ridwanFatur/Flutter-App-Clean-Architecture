import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/feature/movie_list/movie_list_notifier.dart';
import 'package:flutter_clean_architecture/feature/movie_list/movie_list_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_clean_architecture/injection.dart' as di;

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (context) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<MovieListNotifier>(
                  create: (context) => di.locator<MovieListNotifier>(),
                ),
              ],
              child: const MovieListPage(),
            );
          },
        );
      default:
        return MaterialPageRoute(builder: ((context) => Container()));
    }
  }
}
