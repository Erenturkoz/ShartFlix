import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shartflix/data/models/movie.dart';
import 'package:shartflix/data/models/userprofile.dart';

class UserService {
  final Dio dio;
  final FlutterSecureStorage storage;

  UserService(this.dio, this.storage);

  // Future<Map<String, dynamic>> getProfile() async {
  //   final token = await storage.read(key: 'auth_token');
  //   final response = await dio.get(
  //     'https://caseapi.servicelabs.tech/user/profile', // endpoint varsa buna göre güncelle
  //     options: Options(headers: {'Authorization': 'Bearer $token'}),
  //   );
  //   return response.data['data']; // örnek olarak
  // }

  //

  Future<UserProfile> getUserProfile() async {
    try {
      final token = await storage.read(key: 'auth_token');

      final response = await dio.get(
        'https://caseapi.servicelabs.tech/user/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      final raw = response.data;
      print("✔️ Response: $raw");

      final data = raw['data'];
      print("✔️ DATA: $data");

      return UserProfile.fromJson(data);
    } catch (e, s) {
      print("⛔ getUserProfile içinde hata: $e");
      print("🔍 Stacktrace: $s");
      rethrow; // üst seviyeye fırlat, orada yakalayacağız
    }
  }

  Future<List<Movie>> getFavoriteMovies() async {
    try {
      final token = await storage.read(key: 'auth_token');
      final response = await dio.get(
        'https://caseapi.servicelabs.tech/movie/favorites',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      print("✅ Favori response: ${response.data}");

      final raw = response.data;
      final List moviesJson = raw['data']; // ✔️ doğru yol

      print("🎯 Film sayısı: ${moviesJson.length}");

      return moviesJson.map<Movie>((json) => Movie.fromJson(json)).toList();
    } catch (e, s) {
      print("⛔ Hata getFavoriteMovies: $e");
      print("🔍 Stacktrace: $s");
      return [];
    }
  }
  // Future<UserProfile> getUserProfile() async {
  //   final token = await storage.read(key: 'auth_token');
  //   final response = await dio.get(
  //     'https://caseapi.servicelabs.tech/user/profile',
  //     options: Options(headers: {'Authorization': 'Bearer $token'}),
  //   );

  //   final data = response.data['data'];
  //   print('👤 Profil yanıtı: ${response.data}');
  //   return UserProfile.fromJson(data);
  // }

  // Future<List<Movie>> getFavoriteMovies() async {
  //   final dio = GetIt.I<Dio>();
  //   final storage = GetIt.I<FlutterSecureStorage>();
  //   final token = await storage.read(key: 'auth_token');
  //   final response = await dio.get(
  //     'https://caseapi.servicelabs.tech/movie/favorites',
  //     options: Options(headers: {'Authorization': 'Bearer $token'}),
  //   );

  //   final moviesJson = response.data['data']['movies'];
  //   if (moviesJson == null) return [];
  //   return List<Movie>.from(moviesJson.map((e) => Movie.fromJson(e)));
  // }
  // Future<List<Movie>> getFavoriteMovies() async {
  //   final token = await storage.read(key: 'auth_token');
  //   final response = await dio.get(
  //     'https://caseapi.servicelabs.tech/movie/favorites',
  //     options: Options(headers: {'Authorization': 'Bearer $token'}),
  //   );

  //   final moviesJson = response.data['data']['movies'];
  //   if (moviesJson == null) return [];
  //   return List<Movie>.from(moviesJson.map((e) => Movie.fromJson(e)));
  // }
  // Future<List<Movie>> getFavoriteMovies() async {
  //   final token = await storage.read(key: 'auth_token');

  //   final response = await dio.get(
  //     'https://caseapi.servicelabs.tech/movie/favorites',
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );

  //   final data = response.data['movies'] as List;
  //   return data.map((e) => Movie.fromJson(e)).toList();
  // }
}
