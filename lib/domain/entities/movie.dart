import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final DateTime? releaseDate;
  final String overview;
  final double voteAverage;
  final String? posterImagePath;
  final String? posterImageSmallPath;

  const Movie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.overview,
    required this.voteAverage,
    required this.posterImagePath,
    required this.posterImageSmallPath,
  });

  @override
  List<Object?> get props => [id, title, releaseDate, overview, voteAverage];
}
