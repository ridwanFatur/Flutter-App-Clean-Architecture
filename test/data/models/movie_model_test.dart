import 'dart:convert';
import 'package:flutter_clean_architecture/core/constants/urls.dart';
import 'package:flutter_clean_architecture/data/models/movie_model.dart';
import 'package:flutter_clean_architecture/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import '../../helpers/json_reader.dart';

void main() {
  DateTime testDateTime = DateFormat("yyyy-MM-dd").parse("2022-06-08");

  MovieModel testMovieModel = MovieModel(
    id: 1,
    title: "title",
    releaseDate: testDateTime,
    overview: "overview",
    voteAverage: 1,
    posterImagePath: "posterImagePath",
  );

  Movie testMovie(int id) => Movie(
    id: id,
    title: "title",
    releaseDate: testDateTime,
    overview: "overview",
    voteAverage: 1,
    posterImagePath: Urls.posterReguler("posterImagePath"),
    posterImageSmallPath: Urls.posterReguler("posterImagePath"),
  );

  int testTotalPage = 1;
  List<Movie> testMovieList = [
    testMovie(1),
    testMovie(2),
    testMovie(3),
    testMovie(4),
    testMovie(5),
  ];

  test(
    'should be a subclass of movie entity',
    () async {
      // assert
      final result = testMovieModel.toEntity();
      expect(result, equals(testMovie(1)));
    },
  );

  test(
    'should return a valid model from json',
    () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('helpers/dummy_data/dummy_movie_search_response.json'),
      );

      // act
      final result = searchMovieResultFromJson(jsonMap);
      List<Movie> resultMovieList = result.value1;
      int resultTotalPage = result.value2;

      // assert
      expect(resultTotalPage, equals(testTotalPage));
      expect(resultMovieList, equals(testMovieList));
      
    },
  );
}
