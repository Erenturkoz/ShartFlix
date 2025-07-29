import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/movie_service.dart';
import '../../data/models/movie.dart';
import 'package:get_it/get_it.dart';

abstract class MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  MovieLoaded(this.movies);
}

class MovieError extends MovieState {}

class MovieCubit extends Cubit<MovieState> {
  final Dio _dio = Dio();
  final MovieService service = GetIt.I<MovieService>();

  List<Movie> allMovies = [];
  int currentPage = 2;
  bool hasMore = true;
  bool isLoadingMore = false;

  MovieCubit() : super(MovieLoading());

  Future<void> loadMovies({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
      allMovies.clear();
      emit(MovieLoading());
    }
    Future<List<Movie>> getFavoriteMovies() async {
      final response = await _dio.get('/movie/favorites');
      final moviesJson = response.data['movies'];

      if (moviesJson == null) return [];

      return (moviesJson as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (!hasMore || isLoadingMore) return;

    try {
      isLoadingMore = true;
      final movies = await service.fetchMovies(currentPage);
      if (movies.isEmpty) {
        hasMore = false;
      } else {
        allMovies.addAll(movies);
        currentPage++;
      }

      emit(MovieLoaded(List.from(allMovies)));
    } catch (e) {
      emit(MovieError());
    } finally {
      isLoadingMore = false;
    }
  }
}
