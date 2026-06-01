import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/secure_token_storage.dart';
import '../../../../core/services/app_logger.dart';
import '../../data/datasources/auth_services.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthServices(),
      super(AuthInitial());

  Future<void> sendOtp({required String phoneNumber}) async {
    authLog.step('sendOtp() called', 'phone=$phoneNumber');
    emit(AuthLoading());
    try {
      bool otp = await _authRepository.sendOtp(phoneNumber: phoneNumber);
      if (otp) {
        authLog.state('emit CodeSended');
        emit(CodeSended());
      } else {
        authLog.warn('emit AuthError — sendOtp returned false');
        emit(AuthError(message: 'OTP sending failed'));
      }
    } catch (e, st) {
      authLog.error('sendOtp exception', e.toString(), e, st);
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    authLog.step('verifyOtp() called', 'phone=$phoneNumber, code=$code');
    emit(AuthLoading());
    try {
      bool otp = await _authRepository.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
      );
      if (otp) {
        authLog.state('emit CodeVerified');
        emit(CodeVerified());
      } else {
        authLog.warn('emit AuthError — verifyOtp returned false');
        emit(AuthError(message: 'OTP verification failed'));
      }
    } catch (e, st) {
      authLog.error('verifyOtp exception', e.toString(), e, st);
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> checkAuth() async {
    final token = await getAuthToken();
    authLog.step('checkAuth()', 'hasToken=${token != null}');
    if (token != null) {
      emit(CodeVerified());
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> logOut() async {
    authLog.step('logOut() — clearing token');
    await removeAuthToken();
    emit(AuthInitial());
  }
}
