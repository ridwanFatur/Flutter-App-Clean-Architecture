import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/failure.dart';
import 'package:flutter_clean_architecture/core/types.dart';

abstract class MoviesRepository {
  Future<Either<Failure, SearchMovieResult>> getSearchMovieList(
      {required String query, required int page});
}
