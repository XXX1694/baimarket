abstract class AuthRepository {
  Future<bool> sendOtp({required String phoneNumber});
  Future<bool> verifyOtp({required String phoneNumber, required String code});
}
