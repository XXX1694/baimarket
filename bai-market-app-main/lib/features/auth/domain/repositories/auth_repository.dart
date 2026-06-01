import '../../data/datasources/auth_services.dart';

abstract class AuthRepository {
  Future<bool> sendOtp({required String phoneNumber});
  Future<VerifyOtpResult> verifyOtp({
    required String phoneNumber,
    required String code,
  });
  Future<bool> login({required String phoneNumber, required String password});
  Future<bool> setPassword({
    required String token,
    required String newPassword,
  });
}
