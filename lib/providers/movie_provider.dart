import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];

  List<Movie> get movies => _movies;

  // Function to search for movies by title and fetch IMDb rating
  Future<void> searchMovies(String query) async {
    final omdbApiKey = '16491966'; // Your OMDb API Key
    final searchUrl = 'http://www.omdbapi.com/?s=$query&apikey=$omdbApiKey'; // OMDb search by title

    try {
      final response = await http.get(Uri.parse(searchUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['Response'] == 'True') {
          // Fetch rating for each movie using its IMDb ID
          _movies = await Future.wait(
            (data['Search'] as List).map((item) async {
              return await Movie.fromJsonWithRating(item, '76a080fffcmshdb5f5f305fedf69p18cdc8jsn28c5b2e9fd74'); // RapidAPI Key
            }).toList(),
          );
        } else {
          _movies = [];
          print('No movies found for this query');
        }
        notifyListeners();
      } else {
        print('OMDb API error: ${response.statusCode}');
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      print('Search Movies Error: $error');
      throw Exception('Failed to load movies');
    }
  }
}
