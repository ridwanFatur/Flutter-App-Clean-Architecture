import 'package:flutter_clean_architecture/data/data_sources/movies_remote_data_souce.dart';
import 'package:flutter_clean_architecture/data/repositories/movies_repository_impl.dart';
import 'package:flutter_clean_architecture/domain/repositories/movies_repository.dart';
import 'package:flutter_clean_architecture/domain/usecases/get_search_movie_list.dart';
import 'package:flutter_clean_architecture/feature/movie_list/movie_list_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // notifier
  locator.registerFactory(() => MovieListNotifier(locator()));

  // usecase
  locator.registerLazySingleton(() => GetSearchMovieList(locator()));

  // repository
  locator.registerLazySingleton<MoviesRepository>(
    () => MoviesRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );

  // data source
  locator.registerLazySingleton<MoviesRemoteDataSource>(
    () => MoviesRemoteDateSourceImpl(
      client: locator(),
    ),
  );

  // external
  locator.registerLazySingleton(() => http.Client());
}
