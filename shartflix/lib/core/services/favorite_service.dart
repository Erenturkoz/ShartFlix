import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FavoriteService {
  final Dio _dio;
  FavoriteService(this._dio);
  final storage = FlutterSecureStorage();

  Future<List<String>> getFavoriteMovieIds() async {
    try {
      final token = await storage.read(key: 'auth_token');
      final response = await _dio.get(
        'https://caseapi.servicelabs.tech/movie/favorites',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        List movies = response.data['movies'];
        return movies.map<String>((m) => m['id'].toString()).toList();
      } else {
        throw Exception('Favori filmler alınamadı');
      }
    } catch (e) {
      print('Hata: $e');
      return [];
    }
  }

  Future<bool> toggleFavorite(String movieId) async {
    try {
      final token = await storage.read(key: 'auth_token');
      print("TOKEN: $token");
      final response = await _dio.post(
        'https://caseapi.servicelabs.tech/movie/favorite/$movieId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      print('Toggle response: ${response.statusCode}');

      return response.statusCode == 200;
    } on DioException catch (e) {
      print("Favori toggle hatası: ${e.response?.statusCode}");
      print("Sunucu cevabı: ${e.response?.data}");
      return false;
    }
  }
}
