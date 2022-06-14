import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/constants/urls.dart';
import 'package:flutter_clean_architecture/core/exception.dart';
import 'package:flutter_clean_architecture/core/types.dart';
import 'package:flutter_clean_architecture/data/models/movie_model.dart';
import 'package:http/http.dart' as http;

abstract class MoviesRemoteDataSource {
  Future<SearchMovieResult> getMovieList(
      {required String query, required int page});
}

class MoviesRemoteDateSourceImpl implements MoviesRemoteDataSource {
  final http.Client client;
  MoviesRemoteDateSourceImpl({required this.client});

  @override
  Future<SearchMovieResult> getMovieList(
      {required String query, required int page}) async {
    Uri uri = Uri.parse(Urls.searchMovie(Uri.encodeComponent(query), page));
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return searchMovieResultFromJson(json.decode(response.body));
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      throw ServerException();
    }
  }
}

class MoviesRemoteDateSourceDioImpl implements MoviesRemoteDataSource {
  final Dio client;
  MoviesRemoteDateSourceDioImpl({required this.client});

  @override
  Future<SearchMovieResult> getMovieList(
      {required String query, required int page}) async {
    try {
      final response = await client.get(
        Urls.searchMovieUrlDio(Uri.encodeComponent(query), page),
        options: Options(headers: {
          'requiresApiKey': true,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final data = searchMovieResultFromJson(responseData);
        return data;
      } else {
        throw ServerException();
      }
    } on DioError catch (e) {
      print("Dio Error");
      throw ServerException();
    } catch (e) {
      print(e);
      throw ServerException();
    }
  }
}
