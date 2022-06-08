import 'dart:convert';
import 'package:flutter_clean_architecture/core/constants/urls.dart';
import 'package:flutter_clean_architecture/core/exception.dart';
import 'package:flutter_clean_architecture/core/types.dart';
import 'package:flutter_clean_architecture/data/models/movie_model.dart';
import 'package:http/http.dart' as http;

abstract class MoviesRemoteDataSource {
  Future<SearchMovieResult> getMovieList({required String query, required int page});
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
