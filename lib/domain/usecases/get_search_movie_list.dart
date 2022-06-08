
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/failure.dart';
import 'package:flutter_clean_architecture/core/types.dart';
import 'package:flutter_clean_architecture/domain/repositories/movies_repository.dart';

class GetSearchMovieList{
  final MoviesRepository repository;

  GetSearchMovieList(this.repository);
  
  Future<Either<Failure, SearchMovieResult>> call({required String query, required int page}) async {
    return await repository.getSearchMovieList(
      query: query,
      page: page,
    );
  }
}