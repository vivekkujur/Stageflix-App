import 'package:hive/hive.dart';


@HiveType(typeId: 0) // Unique type ID for this model
class Favorite {

  @HiveField(1)
  final int id;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String posterPath;

  @HiveField(4)
   bool fav;

  Favorite({required this.id, required this.title, required this.posterPath , this.fav=false });

  // Convert from JSON
  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'] ?? '',
      fav: json['fav'] ?? '',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'fav':fav


    };
  }
}