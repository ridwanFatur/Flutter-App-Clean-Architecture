import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture/core/constants/urls.dart';
import 'package:flutter_clean_architecture/core/types.dart';
import 'package:flutter_clean_architecture/domain/entities/movie.dart';
import 'package:intl/intl.dart';

SearchMovieResult searchMovieResultFromJson(Map<String, dynamic> json) {
  List<Movie> movieList = List<Movie>.from(
      json["results"].map((e) => MovieModel.fromJson(e).toEntity()));
  int totalPage = json["total_pages"];
  return Tuple2(movieList, totalPage);
}

class MovieModel extends Equatable {
  final int id;
  final String? title;
  final DateTime? releaseDate;
  final String? overview;
  final double? voteAverage;
  final String? posterImagePath;

  const MovieModel({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.overview,
    required this.voteAverage,
    required this.posterImagePath,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    DateTime? releaseDate;
    if (json["release_date"] != null) {
      try {
        releaseDate = DateFormat("yyyy-MM-dd").parse(json["release_date"]);
      } catch (e) {
        releaseDate = null;
      }
    }

    double? voteAverage;
    if (json["vote_average"] != null) {
      if (json["vote_average"] is int) {
        int value = json["vote_average"];
        voteAverage = value.toDouble();
      } else if (json["vote_average"] is double) {
        voteAverage = json["vote_average"];
      }
    }

    return MovieModel(
      id: json["id"],
      title: json["title"],
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      posterImagePath: json["poster_path"],
      overview: json["overview"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "release_date": releaseDate != null
          ? DateFormat("yyyy-MM-dd").format(releaseDate!)
          : null,
      "vote_average": voteAverage,
      "poster_path": posterImagePath,
      "overview": overview,
    };
  }

  Movie toEntity() => Movie(
        id: id,
        title: title ?? "<None>",
        releaseDate: releaseDate,
        overview: overview ?? "<Empty>",
        voteAverage: voteAverage ?? 0.0,
        posterImagePath: posterImagePath != null
            ? Urls.posterReguler(posterImagePath!)
            : null,
        posterImageSmallPath:
            posterImagePath != null ? Urls.posterSmall(posterImagePath!) : null,
      );

  @override
  List<Object?> get props => [id, title, releaseDate, overview, voteAverage];
}
