import 'package:bai_market/features/profile/data/models/profile_model.dart';
import 'package:bai_market/features/profile/domain/repositories/profile_repository.dart';
import 'package:dio/dio.dart';
import '../../../../core/secure_token_storage.dart';
import '../../../../core/urls.dart';

class ProfileServices implements ProfileRepository {
  final Dio _dio = Dio();

  @override
  Future<ProfileModel?> getProfileData() async {
    final url = mainUrl;
    String finalUrl = '${url}profile/me/summary';
    String? token = await getAuthToken();
    if (token == null) return null;
    _dio.options.headers["authorization"] = "Bearer $token";
    try {
      final response = await _dio.get(finalUrl);
      ProfileModel profileModel = ProfileModel.fromJson(response.data);
      if (response.statusCode == 200) {
        return profileModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
