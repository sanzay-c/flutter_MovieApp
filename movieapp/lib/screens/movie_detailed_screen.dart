import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/common/utils.dart';
import 'package:movieapp/model/movie_detailed_model.dart';
import 'package:movieapp/model/movie_recommendation_model.dart';
import 'package:movieapp/services/api_services.dart';

class MovieDetailedScreen extends StatefulWidget {
  const MovieDetailedScreen({super.key, required this.movieId});
  final int movieId;

  @override
  State<MovieDetailedScreen> createState() => _MovieDetailedScreenState();
}

class _MovieDetailedScreenState extends State<MovieDetailedScreen> {
  ApiServices apiServices = ApiServices();

  late Future<MovieDetailModel> movieDetail;
  late Future<MovieRecommendationModel> movieRecommendations;

  @override
  void initState() {
    // Initialize the futures with API calls to fetch movie details and recommendations using the provided movie ID
    movieDetail = apiServices.getMovieDetails(widget.movieId);
    movieRecommendations = apiServices.getMovieRecommendations(widget.movieId);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("hey movie id is:  ${widget.movieId}");

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: movieDetail,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                final movie = snapshot.data; // Extract movie details from the snapshot
                String genreText =
                    movie!.genres.map((genre) => genre.name).join(', ');
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  NetworkImage("$imageUrl${movie.posterPath}"),
                              // fit: BoxFit.cover
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 31, 29, 29),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.only(left: 6),
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const  TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(movie.releaseDate.year.toString()),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Text(
                                  genreText,
                                  // overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            movie.overview,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey, fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FutureBuilder(
                      future: movieRecommendations,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasData) {
                          final movieRecommendations = snapshot.data;

                          return movieRecommendations!.results.isEmpty
                              ? const SizedBox() // no recommendations to display
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("More like this"),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height: 400,
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          // physics: const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  mainAxisSpacing: 15,
                                                  crossAxisSpacing: 5,
                                                  childAspectRatio: 1.5 / 2),
                                          itemCount: movieRecommendations
                                              .results.length,
                                          itemBuilder: (context, index) {
                                            final movie = movieRecommendations
                                                .results[index];
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MovieDetailedScreen(
                                                      movieId: movie.id,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "$imageUrl${movie.posterPath}",
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        }
                        return const Text('something went wrong');
                      },
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}


