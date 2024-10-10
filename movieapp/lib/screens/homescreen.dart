import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movieapp/model/now_playing.dart';
import 'package:movieapp/model/tv_series_model.dart';
import 'package:movieapp/model/upcoming_movie_model.dart';
import 'package:movieapp/screens/search_screen.dart';
import 'package:movieapp/widgets/custom_carousel.dart';
import 'package:movieapp/services/api_services.dart';
import 'package:movieapp/widgets/movie_card_widget.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late Future<UpComingMovieModel> upcomingFuture;
  late Future<NowPlayingMovieModel> nowPlayingFuture;
  late Future<TvSeriesModel> topRatedSeries;

  ApiServices apiServices = ApiServices();

  @override
  void initState() {
    upcomingFuture = apiServices.getUpcomingMovie();
    nowPlayingFuture = apiServices.getNowPlayingMovies();
    topRatedSeries = apiServices.getTopRatedSeries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/logo.png",
          height: 50,
          width: 120,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.search,
                size: 33,
                color: Colors.white,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 30,
              width: 30,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<TvSeriesModel>(
              future: topRatedSeries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data available'));
                } else {
                  return CustomCarouselSlider(data: snapshot.data!);
                }
              },
            ),
            SizedBox(
              height: 250,
              child: MovieCardWidget(
                futureBuilder: upcomingFuture,
                headLineText: "Now Playing",
              ),
            ),
            SizedBox(
              height: 250,
              child: MovieCardWidget(
                futureBuilder: upcomingFuture,
                headLineText: "Upcoming Movie",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
