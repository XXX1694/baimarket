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
      bool otp = await _authRepository.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
      );
      if (otp) {
        emit(CodeVerified());
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
}
