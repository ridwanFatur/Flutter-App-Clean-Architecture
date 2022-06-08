import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/enums/network_result.dart';
import 'package:flutter_clean_architecture/core/types.dart';
import 'package:flutter_clean_architecture/domain/entities/movie.dart';
import 'package:flutter_clean_architecture/feature/movie_list/movie_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

class MockCallbackFunction extends Mock {
  call();
}

void main() {
  late MockGetSearchMovieList mockGetSearchMovieList;
  late MovieListNotifier movieListNotifier;
  final notifyListenerCallback = MockCallbackFunction();

  setUp(() {
    mockGetSearchMovieList = MockGetSearchMovieList();
    movieListNotifier = MovieListNotifier(mockGetSearchMovieList);
    movieListNotifier.addListener((){
      notifyListenerCallback.call();
      print(movieListNotifier.mainNetworkResult.runtimeType);
    });
    reset(notifyListenerCallback);
  });

  test(
    'initial state should be empty',
    () {
      expect(movieListNotifier.mainNetworkResult,
          isA<ResultEmpty<SearchMovieResult>>());
    },
  );

  test('should emit [loading, has data] when data is gotten successfully',
      () async {
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

    when(mockGetSearchMovieList.call(query: testQuery, page: testPage))
        .thenAnswer((_) async => Right(testResult));
    await movieListNotifier.loadMainData();
    verify(mockGetSearchMovieList.call(query: testQuery, page: testPage));
    verify(notifyListenerCallback()).called(2);
  });
}
