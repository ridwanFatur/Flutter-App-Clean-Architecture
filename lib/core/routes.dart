import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/feature/movie_list/movie_list_notifier.dart';
import 'package:flutter_clean_architecture/feature/movie_list/movie_list_page.dart';
import 'package:flutter_clean_architecture/feature/rxdart_screen/counter_bloc_notifier.dart';
import 'package:flutter_clean_architecture/feature/rxdart_screen/rx_dart_screen.dart';
import 'package:flutter_clean_architecture/feature/use_selector_screen/simple_notifier.dart';
import 'package:flutter_clean_architecture/feature/use_selector_screen/use_selector_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_clean_architecture/injection.dart' as di;

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/use_selector":
        return MaterialPageRoute(
          builder: (context) {
            // return const UseSelectorScreen();
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<SimpleNotifier>(
                  create: (context) => di.locator<SimpleNotifier>(),
                ),
              ],
              child: const UseSelectorScreen(),
            );
          },
        );
      case "/rx_dart":
        return MaterialPageRoute(
          builder: (context) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<CounterBlocNotifier>(
                  create: (context) => di.locator<CounterBlocNotifier>(),
                ),
              ],
              child: const RxDartScreen(),
            );
          },
        );
      // case "/":
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return MultiProvider(
      //         providers: [
      //           ChangeNotifierProvider<MovieListNotifier>(
      //             create: (context) => di.locator<MovieListNotifier>(),
      //           ),
      //         ],
      //         child: const MovieListPage(),
      //       );
      //     },
      //   );
      default:
        return MaterialPageRoute(builder: ((context) => Container()));
    }
  }
}
