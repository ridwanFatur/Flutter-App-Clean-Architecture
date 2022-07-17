import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/dio_interceptor.dart';
import 'package:flutter_clean_architecture/data/data_sources/movies_remote_data_souce.dart';
import 'package:flutter_clean_architecture/data/repositories/movies_repository_impl.dart';
import 'package:flutter_clean_architecture/domain/repositories/movies_repository.dart';
import 'package:flutter_clean_architecture/domain/usecases/get_search_movie_list.dart';
import 'package:flutter_clean_architecture/feature/movie_list/movie_list_notifier.dart';
import 'package:flutter_clean_architecture/feature/rxdart_screen/counter_bloc_notifier.dart';
import 'package:flutter_clean_architecture/feature/use_selector_screen/simple_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // notifier
  locator.registerFactory(() => MovieListNotifier(locator()));
  locator.registerFactory(() => CounterBlocNotifier());
  locator.registerFactory(() => SimpleNotifier());

  // usecase
  locator.registerLazySingleton(() => GetSearchMovieList(locator()));

  // repository
  locator.registerLazySingleton<MoviesRepository>(
    () => MoviesRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );

  // data source
  // locator.registerLazySingleton<MoviesRemoteDataSource>(
  //   () => MoviesRemoteDateSourceImpl(
  //     client: locator(),
  //   ),
  // );
    locator.registerLazySingleton<MoviesRemoteDataSource>(
    () => MoviesRemoteDateSourceDioImpl(
      client: locator(),
    ),
  );

  // external
  final Dio dio = Dio();
  dio.interceptors.add(DioInterceptors(dio));

  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => dio);
  
}
