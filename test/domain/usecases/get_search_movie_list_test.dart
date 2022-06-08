import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/failure.dart';
import 'package:flutter_clean_architecture/core/types.dart';
import 'package:flutter_clean_architecture/domain/entities/movie.dart';
import 'package:flutter_clean_architecture/domain/usecases/get_search_movie_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMoviesRepository mockMoviesRepository;
  late GetSearchMovieList usecase;

  setUp(() {
    mockMoviesRepository = MockMoviesRepository();
    usecase = GetSearchMovieList(mockMoviesRepository);
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
  ];
  const int testTotalPage = 1;
  SearchMovieResult testResult = Tuple2(testMovieList, testTotalPage);

  const String testQuery = "test";
  const int testPage = 1;

  test('should get movie list from the repository', () async {
    // arrange
    when(mockMoviesRepository.getSearchMovieList(
            query: testQuery, page: testPage))
        .thenAnswer((_) async => Right(testResult));

    // act
    final result = await usecase.call(query: testQuery, page: testPage);

    // assert
    expect(result, equals(Right(testResult)));
  });

  test(
    'should return server failure from the repository',
    () async {
      // arrange
      when(mockMoviesRepository.getSearchMovieList(
              query: testQuery, page: testPage))
          .thenAnswer((_) async => const Left(ServerFailure("")));

      // act
      final result = await usecase.call(query: testQuery, page: testPage);

      // assert
      expect(result, equals(const Left(ServerFailure(""))));
    },
  );
}
