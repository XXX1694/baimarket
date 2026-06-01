import 'package:dio/dio.dart';
import '../models/user_address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

class UserAddressRemoteDatasource {
  final Dio dio;
  final String baseUrl;

  UserAddressRemoteDatasource(this.dio, this.baseUrl);

  Future<List<UserAddressModel>> getAddresses() async {
    final token = await getToken();
    final response = await dio.get(
      '${baseUrl}user-address',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return (response.data as List)
          .map((e) => UserAddressModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Ошибка получения адресов: ${response.statusCode}');
    }
  }

  Future<void> addAddress(UserAddressModel address) async {
    final token = await getToken();
    final response = await dio.post(
      '${baseUrl}user-address',
      data: address.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Ошибка добавления адреса: ${response.statusCode}');
    }
  }

  Future<void> deleteAddress(int id) async {
    final token = await getToken();
    final response = await dio.delete(
      '${baseUrl}user-address/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Ошибка удаления адреса: ${response.statusCode}');
    }
  }
}
