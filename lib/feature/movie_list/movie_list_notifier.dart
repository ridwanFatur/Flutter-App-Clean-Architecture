import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/enums/network_result.dart';
import 'package:flutter_clean_architecture/core/types.dart';
import 'package:flutter_clean_architecture/domain/entities/movie.dart';
import 'package:flutter_clean_architecture/domain/usecases/get_search_movie_list.dart';

class MovieListNotifier extends ChangeNotifier {
  static const String defaultQuery = "test";
  String query = defaultQuery;
  int totalPage = 1;
  int currentPage = 1;
  NetworkResult<SearchMovieResult> mainNetworkResult = ResultEmpty();
  NetworkResult<SearchMovieResult> paginationNetworkResult = ResultEmpty();
  List<Movie> movieList = [];
  final GetSearchMovieList _getSearchMovieList;

  MovieListNotifier(this._getSearchMovieList);
  Timer? _debounce;

  Future<void> loadMainData() async {
    currentPage = 1;
    mainNetworkResult = ResultLoading();
    movieList = [];
    notifyListeners();

    final result =
        await _getSearchMovieList.call(query: query, page: currentPage);
    result.fold(
      (failure) {
        mainNetworkResult = ResultError(failure.message);
        notifyListeners();
      },
      (data) {
        mainNetworkResult = ResultHasData(data);
        movieList = List.from(data.value1);
        totalPage = data.value2;
        notifyListeners();
      },
    );
  }

  Future<void> changeQuery(String query) async {
    if (this.query != query) {
      if (query.isEmpty) {
        this.query = defaultQuery;
      } else {
        this.query = query;
      }

      if (_debounce?.isActive ?? false) {
        _debounce?.cancel();
      }
      _debounce = Timer(const Duration(milliseconds: 500), () {
        loadMainData();
      });
    }
  }

  bool canLoadPagination() {
    return currentPage < totalPage &&
        paginationNetworkResult is! ResultError &&
        paginationNetworkResult is! ResultLoading;
  }

  Future<void> loadPaginationData() async {
    paginationNetworkResult = ResultLoading();
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));

    final result =
        await _getSearchMovieList.call(query: query, page: currentPage + 1);

    result.fold(
      (failure) {
        paginationNetworkResult = ResultError(failure.message);
        notifyListeners();
      },
      (data) {
        paginationNetworkResult = ResultHasData(data);
        movieList.addAll(data.value1);
        currentPage += 1;
        print("Load $currentPage");
        notifyListeners();
      },
    );
  }
}
