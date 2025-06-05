import 'package:bai_market/features/profile/data/models/profile_model.dart';
import 'package:bai_market/features/profile/domain/repositories/profile_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/urls.dart';

class ProfileServices implements ProfileRepository {
  final Dio _dio = Dio();
  final _storage = SharedPreferences.getInstance();

  @override
  Future<ProfileModel?> getProfileData() async {
    final url = mainUrl;
    var storage = await _storage;
    String finalUrl = '${url}profile/me/summary';
    String? token = storage.getString('auth_token');
    if (token == null) return null;
    // String token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwNDI0OCwiaWF0IjoxNzQ0OTk3Mjk2LCJleHAiOjE3NDU2MDIwOTZ9.Bhm9ULK7tZPjaQg8zcmx6YbWV-rkmTCA_eyFb8fb_RM';
    _dio.options.headers["authorization"] = "Bearer $token";
    try {
      final response = await _dio.get(finalUrl);
      print(response.data);
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
