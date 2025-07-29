import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/services/auth_service.dart';
import 'package:get_it/get_it.dart';

// States:
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

// Cubit:
class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit()
    : authService = GetIt.instance<AuthService>(),
      super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final success = await authService.login(email, password);
    if (success) {
      emit(AuthSuccess());
    } else {
      emit(AuthFailure("Giriş başarısız"));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    final success = await authService.register(name, email, password);
    if (success) {
      emit(AuthSuccess());
      print('Kayıt başarılı, yönlendiriliyor...');
    } else {
      emit(AuthFailure("Kayıt başarısız"));
    }
  }
}
