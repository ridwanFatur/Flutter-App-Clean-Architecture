import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/enums/network_result.dart';
import 'package:flutter_clean_architecture/core/types.dart';
import 'package:flutter_clean_architecture/domain/entities/movie.dart';
import 'package:flutter_clean_architecture/feature/movie_list/layout.dart';
import 'package:flutter_clean_architecture/feature/movie_list/movie_list_notifier.dart';
import 'package:flutter_clean_architecture/feature/movie_list/movie_list_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieListNotifier mockMovieListNotifier;

  setUpAll(() async {
    HttpOverrides.global = null;
    final di = GetIt.instance;
    di.registerFactory(() => mockMovieListNotifier);
  });

  setUp(() {
    mockMovieListNotifier = MockMovieListNotifier();
  });

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
    testMovie(3),
    testMovie(4),
    testMovie(5),
    testMovie(6),
    testMovie(7),
    testMovie(8),
    testMovie(9),
  ];

  const int testTotalPage = 1;
  SearchMovieResult testResult = Tuple2(testMovieList, testTotalPage);

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MovieListNotifier>.value(
            value: mockMovieListNotifier),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'text field should trigger state to change from empty to loading',
    (WidgetTester tester) async {
      // arrange
      when(mockMovieListNotifier.mainNetworkResult)
          .thenReturn(ResultEmpty<SearchMovieResult>());

      // act
      await tester.pumpWidget(_makeTestableWidget(const MovieListPage()));
      // Wait for load Main
      await tester.pump(const Duration(seconds: 1));

      await tester.enterText(find.byType(TextField), 'movie');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // assert
      verify(mockMovieListNotifier.loadMainData()).called(1);
      verify(mockMovieListNotifier.changeQuery("movie")).called(1);

      expect(find.byType(TextField), equals(findsOneWidget));
    },
  );

  testWidgets(
    'should show progress indicator when state is loading',
    (WidgetTester tester) async {
      // arrange
      when(mockMovieListNotifier.mainNetworkResult)
          .thenReturn(ResultLoading<SearchMovieResult>());

      // act
      await tester.pumpWidget(_makeTestableWidget(const MovieListPage()));
      // Wait for load Main
      await tester.pump(const Duration(seconds: 1));

      // assert
      expect(find.byType(LoadingLayout), equals(findsOneWidget));
    },
  );

  testWidgets(
    'should show widget contain weather data when state is has data',
    (WidgetTester tester) async {
      // arrange
      when(mockMovieListNotifier.mainNetworkResult)
          .thenReturn(ResultHasData<SearchMovieResult>(testResult));
      when(mockMovieListNotifier.movieList).thenReturn(testResult.value1);
      when(mockMovieListNotifier.paginationNetworkResult)
          .thenReturn(ResultEmpty<SearchMovieResult>());

      // act
      await tester.pumpWidget(_makeTestableWidget(const MovieListPage()));
      // Wait for load Main
      await tester.pump(const Duration(seconds: 1));

      // assert
      expect(find.byType(DataListLayout), equals(findsOneWidget));
    },
  );

  testWidgets(
    'should show widget contain weather data when state is output no data',
    (WidgetTester tester) async {
      // arrange
      when(mockMovieListNotifier.mainNetworkResult)
          .thenReturn(ResultHasData<SearchMovieResult>(const Tuple2([], 1)));
      when(mockMovieListNotifier.movieList).thenReturn([]);
      when(mockMovieListNotifier.paginationNetworkResult)
          .thenReturn(ResultEmpty<SearchMovieResult>());

      // act
      await tester.pumpWidget(_makeTestableWidget(const MovieListPage()));
      // Wait for load Main
      await tester.pump(const Duration(seconds: 1));

      // assert
      expect(find.byType(NoDataLayout), equals(findsOneWidget));
    },
  );

  testWidgets(
    'scroll to check pagination',
    (WidgetTester tester) async {
      // arrange
      when(mockMovieListNotifier.mainNetworkResult)
          .thenReturn(ResultHasData<SearchMovieResult>(testResult));
      when(mockMovieListNotifier.movieList).thenReturn(testResult.value1);
      when(mockMovieListNotifier.paginationNetworkResult)
          .thenReturn(ResultEmpty<SearchMovieResult>());
      when(mockMovieListNotifier.canLoadPagination()).thenReturn(true);

      // act
      await tester.pumpWidget(_makeTestableWidget(const MovieListPage()));
      // Wait for load Main
      await tester.pump(const Duration(seconds: 1));
      await tester.ensureVisible(find.byKey(Key("${testMovieList[9].id}")));

      // assert
      verify(mockMovieListNotifier.canLoadPagination()).called(1);
      verify(mockMovieListNotifier.loadPaginationData()).called(1);
      expect(find.byType(DataListLayout), equals(findsOneWidget));
    },
  );
}
