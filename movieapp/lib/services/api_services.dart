import 'dart:convert';
import 'dart:developer';

import 'package:movieapp/common/utils.dart';

import 'package:http/http.dart' as http;
import 'package:movieapp/model/movie_detailed_model.dart';
import 'package:movieapp/model/movie_recommendation_model.dart';
import 'package:movieapp/model/now_playing.dart';
import 'package:movieapp/model/search_model.dart';
import 'package:movieapp/model/tv_series_model.dart';
import 'package:movieapp/model/upcoming_movie_model.dart';

// Base URL for The Movie Database API
const baseUrl = "https://api.themoviedb.org/3/";
// API key for authentication
var key = "?api_key=$apikey";
late String endpoint; // To store the endpoint for the API calls

class ApiServices {
  // Fetch upcoming movies from the API
  Future<UpComingMovieModel> getUpcomingMovie() async {
    endpoint = 'movie/upcoming'; // Set the endpoint for upcoming movies
    final url = "$baseUrl$endpoint$key"; // Set the endpoint for upcoming movies

    final response = await http.get(Uri.parse(url)); // Make the GET reques

    // Check if the response was successful
    if(response.statusCode == 200){
      log("success response");  // Log success
      return UpComingMovieModel.fromJson(jsonDecode(response.body)); // Parse and return the data
    } else {
      throw Exception("Faile to load upcoming movies");
    }
  }

  Future<NowPlayingMovieModel> getNowPlayingMovies() async {
    endpoint = 'movie/now_playing';
    final url = "$baseUrl$endpoint$key";

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){
      log("success response on now playing");
      return NowPlayingMovieModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Faile to load on now palying movies");
    }
  }

  Future<TvSeriesModel> getTopRatedSeries() async {
    endpoint = 'tv/top_rated';
    final url = "$baseUrl$endpoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("success response on top rated series: ");
      return TvSeriesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load top rated tv series");
  }

  Future<SearchedModel> getSearchedMovie(String searchText) async {
    endpoint = 'search/movie?query=$searchText';
    final url = "$baseUrl$endpoint";
    print("searched url is: $url");
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYmIyYWQ4ODFkZjI4ZTMzODQyZjQ1ZjUzMTNlMmIyMSIsIm5iZiI6MTcyNzYyODAzMy41MDQ4NDQsInN1YiI6IjY1ZWVmNGJhZjVjYjIxMDE4NTQ1YzhmNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.BUIwE_h8rXo1Y6ToWO6WMrh63aJySuIgME8-eh1vHsQ",
    });

    if (response.statusCode == 200) {
      log("success response on search query: ");
      return SearchedModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load searched series");
  }

   Future<MovieRecommendationModel> getPopularMovies() async {
    endpoint = 'movie/popular';
    final url = "$baseUrl$endpoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("success on popular movie: ");
      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load popular movies");
  }

  Future<MovieDetailModel> getMovieDetails(int movieId) async {
    endpoint = 'movie/$movieId';
    final url = "$baseUrl$endpoint$key";

    print("search url is: ${url}");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("success on movie detailed model: ");
      return MovieDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load movies details");
  }

  Future<MovieRecommendationModel> getMovieRecommendations(int movieId) async {
    endpoint = 'movie/$movieId/recommendations';
    final url = "$baseUrl$endpoint$key";

    print("recommendations url is: ${url}");  
    
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("success on movie detailed model: ");
      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load movies recommendations");
  }
}