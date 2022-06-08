import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/exception.dart';
import 'package:flutter_clean_architecture/core/failure.dart';
import 'package:flutter_clean_architecture/core/types.dart';
import 'package:flutter_clean_architecture/data/repositories/movies_repository_impl.dart';
import 'package:flutter_clean_architecture/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMoviesRemoteDataSource dataSource;
  late MoviesRepositoryImpl repository;

  setUp(() {
    dataSource = MockMoviesRemoteDataSource();
    repository = MoviesRepositoryImpl(
      remoteDataSource: dataSource,
    );
  });

  const String testQuery = "test";
  const int testPage = 1;

  Movie testMovie(int id) => Movie(
        id: id,
        title: "title",
        releaseDate: null,
        overview: "overview",
        voteAverage: 0,
        posterImagePath: null,
        posterImageSmallPath: null,
      );

  List<Movie> testMovieList = [
    testMovie(0),
    testMovie(1),
    testMovie(2),
  ];
  const int testTotalPage = 1;
  SearchMovieResult testResult = Tuple2(testMovieList, testTotalPage);

  test(
    'should return list movie when a call to data source is successful',
    () async {
      // arrange
      when(dataSource.getMovieList(query: testQuery, page: testPage))
          .thenAnswer((_) async => testResult);

      // act
      final result =
          await repository.getSearchMovieList(query: testQuery, page: testPage);

      // assert
      verify(dataSource.getMovieList(query: testQuery, page: testPage));
      expect(result, isA<Right<Failure, SearchMovieResult>>());
      result.fold(
        (failure) {
          throw Exception("Error Failure");
        },
        (data) {
          List<Movie> resultMovieList = data.value1;
          int resultTotalPage = data.value2;
          expect(resultMovieList, equals(testMovieList));
          expect(resultTotalPage, equals(testTotalPage));
        },
      );
    },
  );

  test(
    'should return server failure when a call to data source is unsuccessful',
    () async {
      // arrange
      when(dataSource.getMovieList(query: testQuery, page: testPage))
          .thenThrow(ServerException());

      // act
      final result =
          await repository.getSearchMovieList(query: testQuery, page: testPage);

      // assert
      verify(dataSource.getMovieList(query: testQuery, page: testPage));
      expect(result, isA<Left<Failure, SearchMovieResult>>());
      expect(result, equals(const Left(ServerFailure(''))));
    },
  );

  test(
    'should return connection failure when the device has no internet',
    () async {
      // arrange
      when(dataSource.getMovieList(query: testQuery, page: testPage))
          .thenThrow(const SocketException('Random Param'));

      // act
      final result =
          await repository.getSearchMovieList(query: testQuery, page: testPage);

      // assert
      verify(dataSource.getMovieList(query: testQuery, page: testPage));
      expect(
        result,
        equals(
            const Left(ConnectionFailure('Failed to connect to the network'))),
      );
    },
  );
}
