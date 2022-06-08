import 'dart:convert';
import 'package:flutter_clean_architecture/core/constants/urls.dart';
import 'package:flutter_clean_architecture/core/exception.dart';
import 'package:flutter_clean_architecture/core/types.dart';
import 'package:flutter_clean_architecture/data/data_sources/movies_remote_data_souce.dart';
import 'package:flutter_clean_architecture/data/models/movie_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late MoviesRemoteDateSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = MoviesRemoteDateSourceImpl(client: mockHttpClient);
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
    when(
      mockHttpClient.get(Uri.parse(Urls.searchMovie(testQuery, testPage))),
    ).thenAnswer(
      (_) async => http.Response(
          readJson('helpers/dummy_data/dummy_movie_search_response.json'), 200),
    );

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
      when(
        mockHttpClient.get(Uri.parse(Urls.searchMovie(testQuery, testPage))),
      ).thenAnswer(
        (_) async => http.Response('Not found', 404),
      );

      // act
      final call = dataSource.getMovieList(query: testQuery, page: testPage);

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    },
  );
}
