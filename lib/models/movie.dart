import 'dart:convert';
import 'package:http/http.dart' as http;

class Movie {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String posterUrl;
  final String imdbRating; // New field for IMDb rating

  Movie({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.type,
    required this.posterUrl,
    required this.imdbRating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'],
      year: json['Year'],
      imdbID: json['imdbID'],
      type: json['Type'],
      posterUrl: json['Poster'] != 'N/A' ? json['Poster'] : 'https://via.placeholder.com/150',
      imdbRating: 'N/A', // Default value
    );
  }

  // Factory method to create a Movie with IMDb rating
  static Future<Movie> fromJsonWithRating(Map<String, dynamic> json, String rapidApiKey) async {
    final ratingResponse = await http.get(
      Uri.parse('https://imdb-ratings1.p.rapidapi.com/imdb/${json['imdbID']}/rating'),
      headers: {
        'X-Rapidapi-Key': rapidApiKey,
        'X-Rapidapi-Host': 'imdb-ratings1.p.rapidapi.com',
      },
    );

    if (ratingResponse.statusCode == 200) {
      final ratingData = jsonDecode(ratingResponse.body);
      return Movie(
        title: json['Title'],
        year: json['Year'],
        imdbID: json['imdbID'],
        type: json['Type'],
        posterUrl: json['Poster'] != 'N/A' ? json['Poster'] : 'https://via.placeholder.com/150',
        imdbRating: ratingData['averageRating'].toString(), // Fetch and parse IMDb rating
      );
    } else {
      // Return the movie without IMDb rating if the request fails
      return Movie.fromJson(json);
    }
  }
}
