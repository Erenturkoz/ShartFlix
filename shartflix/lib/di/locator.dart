import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shartflix/core/services/auth_service.dart';
import 'package:shartflix/core/services/favorite_service.dart';
import 'package:shartflix/core/services/movie_service.dart';
import 'package:shartflix/core/services/user_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
  getIt.registerLazySingleton(() => AuthService(getIt(), getIt()));
  getIt.registerLazySingleton(() => MovieService(getIt(), getIt()));
  getIt.registerLazySingleton(() => UserService(getIt(), getIt()));
  getIt.registerLazySingleton(() => FavoriteService(getIt<Dio>()));
}
