import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shartflix/data/models/movie.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    try {
      print("DEBUG: Gelen JSON → $json");
      return UserProfile(
        id: json['id'].toString(),
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        photoUrl: json['photoUrl'] ?? '',
      );
    } catch (e, s) {
      print("⛔ fromJson içinde hata: $e");
      print("🔍 Stacktrace: $s");
      rethrow;
    }
  }

  // factory UserProfile.fromJson(Map<String, dynamic> json) {
  //   print("DEBUG: Gelen JSON → $json");
  //   return UserProfile(
  //     id: json['id'].toString(),
  //     name: json['name'] ?? '',
  //     email: json['email'] ?? '',
  //     photoUrl: json['photoUrl'] ?? '',
  //     token: json['token'],
  //   );
  // }
  // factory UserProfile.fromJson(Map<String, dynamic> json) {
  //   return UserProfile(
  //     id: json['_id'].toString(), // güvenli olan bu
  //     name: json['name'] ?? '',
  //     email: json['email'] ?? '',
  //     photoUrl: json['photoUrl'],
  //     // favoriteMovies: (json['favorites'] as List)
  //     //     .map((e) => Movie.fromJson(e))
  //     //     .toList(),
  //   );
  // }
}
