import 'package:flutter_clean_architecture/data/data_sources/movies_remote_data_souce.dart';
import 'package:flutter_clean_architecture/domain/repositories/movies_repository.dart';
import 'package:flutter_clean_architecture/domain/usecases/get_search_movie_list.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

// command
// flutter pub run build_runner build

@GenerateMocks([
  MoviesRepository,
  MoviesRemoteDataSource,
  GetSearchMovieList,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main(){}