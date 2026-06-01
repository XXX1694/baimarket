import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/auth_services.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthServices(),
      super(AuthInitial());

  Future<void> sendOtp({required String phoneNumber}) async {
    emit(AuthLoading());
    try {
      bool otp = await _authRepository.sendOtp(phoneNumber: phoneNumber);
      if (otp) {
        emit(CodeSended());
      } else {
        emit(AuthError(message: 'OTP sending failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
      );
      if (result.success) {
        if (result.needsPasswordSetup) {
          emit(PasswordSetupRequired(token: result.accessToken ?? ''));
        } else {
          emit(CodeVerified());
        }
      } else {
        emit(AuthError(message: 'OTP verification failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> checkAuth() async {
    final storage0 = SharedPreferences.getInstance();
    var storage = await storage0;
    String? token = storage.getString('auth_token');
    if (token != null) {
      emit(CodeVerified());
    } else {
      emit(AuthError(message: 'Authentication check failed'));
    }
  }

  Future<void> logOut() async {
    final storage0 = SharedPreferences.getInstance();
    var storage = await storage0;
    storage.remove('auth_token');
    emit(AuthInitial());
  }

  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      bool result = await _authRepository.login(
        phoneNumber: phoneNumber,
        password: password,
      );
      if (result) {
        emit(CodeVerified());
      } else {
        emit(AuthError(message: 'Login failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> setPassword({
    required String token,
    required String newPassword,
  }) async {
    emit(AuthLoading());
    try {
      bool result = await _authRepository.setPassword(
        token: token,
        newPassword: newPassword,
      );
      if (result) {
        emit(CodeVerified());
      } else {
        emit(AuthError(message: 'Не удалось установить пароль'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
