import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileService {
  final Dio _dio = Dio();
  final storage = FlutterSecureStorage();

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      final token = await storage.read(
        key: 'auth_token',
      ); // Token daha önce login sırasında kaydedilmiş olmalı
      if (token == null) throw Exception('Token bulunamadı');

      final response = await _dio.get(
        'https://caseapi.servicelabs.tech/user/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Hata kodu: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Profil verisi alınırken hata oluştu: $e');
      return null;
    }
  }
}
