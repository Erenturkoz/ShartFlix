import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio dio;
  final FlutterSecureStorage storage;

  AuthService(this.dio, this.storage);

  Future<bool> login(String email, String password) async {
    try {
      final response = await dio.post(
        'https://caseapi.servicelabs.tech/user/login',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print('Login status: ${response.statusCode}');
      print('Login body: ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data['data']['token'];
        if (token != null) {
          await storage.write(key: 'auth_token', value: token);
          return true;
        } else {
          print('❌ Token null geldi!');
          return false;
        }
      }
      return false;
    } catch (e) {
      print('Login API error: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await dio.post(
        'https://caseapi.servicelabs.tech/user/register',
        data: {'email': email, 'name': name, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 201) {
        final token = response.data['data']['token'];
        await storage.write(key: 'auth_token', value: token);
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('Register API error: ${e.response?.statusCode}');
      print('Register response: ${e.response?.data}');
      return false;
    }
  }
}
