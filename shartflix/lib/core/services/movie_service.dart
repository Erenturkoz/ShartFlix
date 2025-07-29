import 'package:dio/dio.dart';
import 'package:shartflix/data/models/movie.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MovieService {
  final Dio dio;
  final FlutterSecureStorage storage;

  MovieService(this.dio, this.storage);

  Future<List<Movie>> fetchMovies(int page) async {
    final token = await storage.read(key: 'auth_token');

    final response = await dio.get(
      'https://caseapi.servicelabs.tech/movie/list',
      queryParameters: {'page': page},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    print('📦 Response: ${response.statusCode}');
    print('🧾 Response body: ${response.data}');

    // final firstImageUrl = response.data['data']['movies'][0]['Images'][0];
    final data = response.data['data'];
    final List moviesJson = data['movies'];

    return moviesJson.map((e) => Movie.fromJson(e)).toList();
  }

  // Future<void> toggleFavorite(String movieId) async {
  //   final token = await storage.read(key: 'auth_token');
  //   await dio.post(
  //     'https://caseapi.servicelabs.tech/movie/favorite/$movieId',
  //     options: Options(headers: {'Authorization': 'Bearer $token'}),
  //   );
  // }
}
