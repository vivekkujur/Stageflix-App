
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Movie {
  @HiveField(1)
  final int id;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String posterPath;

  @HiveField(4)
  final String backdropPath;

  @HiveField(5)
  final String overview;

  @HiveField(6)
  final String releaseDate;

  @HiveField(7)
  bool isFavorite;

  Movie({
    required this.id,
     this.title="",
     this.posterPath="",
     this.backdropPath="",
     this.overview="",
     this.releaseDate="",
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<dynamic, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title']??json['original_title']??"",
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      overview: json['overview'] ?? '',
      releaseDate: json['release_date'] ?? '',
      isFavorite: json['is_favorite'] ?? false,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'overview': overview,
      'release_date': releaseDate,
      'is_favorite': isFavorite,
    };
  }

  Movie copyWith({
    int? id,
    String? title,
    String? posterPath,
    String? backdropPath,
    String? overview,
    double? voteAverage,
    String? releaseDate,
    bool? isFavorite,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      overview: overview ?? this.overview,
      releaseDate: releaseDate ?? this.releaseDate,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}