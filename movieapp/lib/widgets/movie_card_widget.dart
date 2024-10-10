import 'package:flutter/material.dart';
import 'package:movieapp/common/utils.dart';
import 'package:movieapp/model/upcoming_movie_model.dart';
import 'package:movieapp/screens/movie_detailed_screen.dart';

class MovieCardWidget extends StatelessWidget {
  const MovieCardWidget({
    super.key,
    required this.futureBuilder,
    required this.headLineText,
  });
  final Future<UpComingMovieModel> futureBuilder; // Future holding the upcoming movie data
  final String headLineText; // Headline to display above the movie cards

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureBuilder,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          // If the future has completed successfully and data is available
          var data = snapshot.data!.results; // Extract the list of movie results
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headLineText,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded( // Expanded widget to fill available vertical space
                child: ListView.builder(
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailedScreen(
                              movieId: data[index].id, // Pass the movie ID to the detailed screen
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Image.network(
                          "$imageUrl${data[index].posterPath}",
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
