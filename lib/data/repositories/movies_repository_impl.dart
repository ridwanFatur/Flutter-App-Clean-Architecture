import 'dart:io';
import 'package:flutter_clean_architecture/core/exception.dart';
import 'package:flutter_clean_architecture/core/types.dart';
import 'package:flutter_clean_architecture/data/data_sources/movies_remote_data_souce.dart';
import 'package:flutter_clean_architecture/core/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/domain/repositories/movies_repository.dart';

class MoviesRepositoryImpl implements MoviesRepository{
  final MoviesRemoteDataSource remoteDataSource;
  MoviesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SearchMovieResult>> getSearchMovieList({required String query, required int page}) async {
    try{
      final result = await remoteDataSource.getMovieList(query: query, page: page);
      return Right(result);
    } on ServerException{
      return const Left(ServerFailure(''));
    } on SocketException{
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch(e){
      return const Left(UnexpectedFailure("There is Unexpected Error"));
    }
  }

}