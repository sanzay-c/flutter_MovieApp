import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/common/utils.dart';
import 'package:movieapp/model/movie_recommendation_model.dart';
import 'package:movieapp/model/search_model.dart';
import 'package:movieapp/screens/movie_detailed_screen.dart';
import 'package:movieapp/services/api_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searhController = TextEditingController();
  ApiServices apiServices = ApiServices();

  // Future to hold popular movies data
  late Future<MovieRecommendationModel> popularMovies;

  // Model to store searched movie results
  SearchedModel? searchedModel;

  void search(String query) {
    apiServices.getSearchedMovie(query).then((results) {
      setState(() {
        searchedModel = results;
      });
    });
  }

  @override
  void initState() {
    // Fetch popular movies on initialization
    popularMovies = apiServices.getPopularMovies();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose the text controller to free up resources
    searhController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: CupertinoSearchTextField(
                  backgroundColor: const Color.fromARGB(168, 61, 53, 53),
                  padding: const EdgeInsets.all(10),
                  controller: searhController,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    // If the search field is empty, reset the searched model
                    if (value.isEmpty) {
                      setState(() {
                        searchedModel = null;
                      });
                    } else {
                      // Perform search with the current text
                      search(searhController.text);
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              // Display popular movies if search field is empty
              searhController.text.isEmpty
                  ? FutureBuilder(
                      future: popularMovies,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          var data = snapshot.data?.results;
                          if (data == null || data.isEmpty) {
                            return const Center(
                              child: Text("No popular Movies found"),
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Top Searches",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                itemCount: data.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailedScreen(
                                            movieId: data[index].id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 200,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.network(
                                            // Display movie poster
                                            "$imageUrl${data[index].posterPath}",
                                          ),
                                          Expanded(
                                            child: Text(
                                              data[index].originalTitle,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                          // Fallback if no condition is met
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    )
                  : searchedModel == null
                      ? const SizedBox.shrink()
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: searchedModel?.results.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 5,
                            childAspectRatio: 1.2 / 2,
                          ),
                          itemBuilder: (context, index) {
                            final backDropPath =
                                searchedModel?.results[index].backdropPath;
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailedScreen(
                                      movieId: searchedModel!.results[index].id,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  if (backDropPath != null)
                                    CachedNetworkImage(
                                      imageUrl: "$imageUrl$backDropPath",
                                      placeholder: (context, url) => Container(
                                        height: 150,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[800],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error_outline),
                                      fit: BoxFit.cover,
                                      height: 150,
                                      width: 100,
                                    )
                                  else
                                    Container(
                                      height: 150,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 70,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      searchedModel!
                                          .results[index].originalTitle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
