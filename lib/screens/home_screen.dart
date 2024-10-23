import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_item.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                movieProvider.searchMovies(value);
              },
            ),
          ),
          // Expanded List of Movies
          Expanded(
            child: movieProvider.movies.isEmpty
                ? Center(child: Text('No movies found'))
                : ListView.builder(
              itemCount: movieProvider.movies.length,
              itemBuilder: (context, index) {
                return MovieItem(movieProvider.movies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}