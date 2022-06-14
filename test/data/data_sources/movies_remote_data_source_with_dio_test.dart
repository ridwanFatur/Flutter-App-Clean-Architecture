import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/constants/urls.dart';
import 'package:flutter_clean_architecture/core/exception.dart';
import 'package:flutter_clean_architecture/core/types.dart';
import 'package:flutter_clean_architecture/data/data_sources/movies_remote_data_souce.dart';
import 'package:flutter_clean_architecture/data/models/movie_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import '../../helpers/json_reader.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late MoviesRemoteDateSourceDioImpl dataSource;

  setUp(() {
    dio = Dio();
    dataSource = MoviesRemoteDateSourceDioImpl(client: dio);
    dioAdapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = dioAdapter;
  });

  final Map<String, dynamic> jsonMap = json.decode(
    readJson('helpers/dummy_data/dummy_movie_search_response.json'),
  );
  final SearchMovieResult searchMovieResult =
      searchMovieResultFromJson(jsonMap);

  const String testQuery = "test";
  const int testPage = 1;

  test('should return search movie result when the response code is 200',
      () async {
    // arrange
    dioAdapter.onGet(Urls.searchMovie(testQuery, testPage), (request) async {
      request.reply(
          200, readJson('helpers/dummy_data/dummy_movie_search_response.json'));
    });

    // act
    final result =
        await dataSource.getMovieList(query: testQuery, page: testPage);

    // assert
    expect(result.value1, equals(searchMovieResult.value1));
    expect(result.value2, equals(searchMovieResult.value2));
  });

  test(
    'should throw a server exception when the response code is 404 or other',
    () async {
      // arrange
      dioAdapter.onGet(Urls.searchMovie(testQuery, testPage), (request) async {
        request.reply(404, 'Not Found');
      });

      // act
      final call = dataSource.getMovieList(query: testQuery, page: testPage);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    },
  );
}
