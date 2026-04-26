import 'package:bai_market/features/profile/data/models/profile_model.dart';
import 'package:bai_market/features/profile/domain/repositories/profile_repository.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/app_dio.dart';
import '../../../../core/urls.dart';

class ProfileServices implements ProfileRepository {
  final Dio _dio = appDio;

  @override
  Future<ProfileModel?> getProfileData() async {
    final finalUrl = '${mainUrl}profile/me/summary';
    try {
      final response = await _dio.get(finalUrl);
      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
