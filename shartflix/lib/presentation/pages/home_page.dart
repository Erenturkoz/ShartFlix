import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shartflix/core/services/favorite_service.dart';
import 'package:shartflix/core/services/movie_service.dart';
import 'package:shartflix/presentation/pages/profile_page.dart';
import 'package:shartflix/presentation/viewmodels/movie_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FavoriteService _favoriteService = FavoriteService(GetIt.I<Dio>());
  List<String> favoriteMovieIds = [];

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  void fetchFavorites() async {
    favoriteMovieIds = await _favoriteService.getFavoriteMovieIds();
    setState(() {});
  }

  void toggleFavorite(String movieId) async {
    bool result = await _favoriteService.toggleFavorite(movieId);
    if (result) {
      if (favoriteMovieIds.contains(movieId)) {
        favoriteMovieIds.remove(movieId);
      } else {
        favoriteMovieIds.add(movieId);
      }
      setState(() {});
    }
  }

  final PageController _pageController = PageController(initialPage: 1000);

  bool _isExpanded = false;

  void _setupScroll(BuildContext context) {
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 100) {
        context.read<MovieCubit>().loadMovies();
      }
    });
  }

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const ModernUserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieCubit()..loadMovies(),
      child: Builder(
        builder: (context) {
          _setupScroll(context);
          return Scaffold(
            backgroundColor: Colors.black,
            body: RefreshIndicator(
              onRefresh: () async {
                await context.read<MovieCubit>().loadMovies(isRefresh: true);
              },
              child: BlocBuilder<MovieCubit, MovieState>(
                builder: (context, state) {
                  if (state is MovieLoading &&
                      context.read<MovieCubit>().currentPage == 1) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MovieLoaded) {
                    return PageView.builder(
                      controller: _pageController,
                      itemBuilder: (_, index) {
                        final movie = state.movies[index % state.movies.length];
                        final isFavorite = favoriteMovieIds.contains(movie.id);
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              movie.posterUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.8),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 80,
                              left: 20,
                              right: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        movie.title,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFavorite
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                        onPressed: () =>
                                            toggleFavorite(movie.id),
                                        // icon: Icon(
                                        //   movie.isFavorite
                                        //       ? Icons.favorite
                                        //       : Icons.favorite_border,
                                        //   color: Colors.white,
                                        // ),
                                        // onPressed: () async {
                                        //   setState(() {
                                        //     movie.isFavorite = !movie
                                        //         .isFavorite; // UI’da hemen yansısın
                                        //   });

                                        //   try {
                                        //     await GetIt.I<MovieService>()
                                        //         .toggleFavorite(movie.id);
                                        //   } catch (e) {
                                        //     // Hata varsa geri al
                                        //     setState(() {
                                        //       movie.isFavorite =
                                        //           !movie.isFavorite;
                                        //     });
                                        //     ScaffoldMessenger.of(
                                        //       context,
                                        //     ).showSnackBar(
                                        //       const SnackBar(
                                        //         content: Text(
                                        //           "Favori işlemi başarısız",
                                        //         ),
                                        //       ),
                                        //     );
                                        //   }
                                        // },
                                      ),

                                      // IconButton(
                                      //   icon: Icon(
                                      //     movie.isFavorite
                                      //         ? Icons.favorite
                                      //         : Icons.favorite_border,
                                      //     color: Colors.white,
                                      //   ),
                                      //   onPressed: () async {
                                      //     setState(() {
                                      //       movie.isFavorite = !movie
                                      //           .isFavorite; // UI'da anlık tepki için
                                      //     });

                                      //     try {
                                      //       await GetIt.I<MovieService>()
                                      //           .toggleFavorite(movie.id);
                                      //     } catch (e) {
                                      //       // Hata durumunda UI'ı geri al
                                      //       setState(() {
                                      //         movie.isFavorite =
                                      //             !movie.isFavorite;
                                      //       });
                                      //       ScaffoldMessenger.of(
                                      //         context,
                                      //       ).showSnackBar(
                                      //         SnackBar(
                                      //           content: Text(
                                      //             'Favori işlemi başarısız',
                                      //           ),
                                      //         ),
                                      //       );
                                      //     }
                                      //   },
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isExpanded = !_isExpanded;
                                      });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie.description,
                                          maxLines: _isExpanded ? null : 2,
                                          overflow: _isExpanded
                                              ? TextOverflow.visible
                                              : TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _isExpanded
                                              ? 'Daha az...'
                                              : 'Daha fazla...',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Text(
                                  //   movie.description,
                                  //   maxLines: 2,
                                  //   overflow: TextOverflow.ellipsis,
                                  //   style: const TextStyle(
                                  //     color: Colors.white70,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Bir hata oluştu',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
