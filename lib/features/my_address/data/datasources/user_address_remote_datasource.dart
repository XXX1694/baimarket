import 'package:dio/dio.dart';

import '../models/user_address_model.dart';

class UserAddressRemoteDatasource {
  final Dio dio;
  final String baseUrl;

  UserAddressRemoteDatasource(this.dio, this.baseUrl);

  Future<List<UserAddressModel>> getAddresses() async {
    final response = await dio.get('${baseUrl}user-address');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return (response.data as List)
          .map((e) => UserAddressModel.fromJson(e))
          .toList();
    }
    throw Exception('Ошибка получения адресов: ${response.statusCode}');
  }

  Future<void> addAddress(UserAddressModel address) async {
    final response = await dio.post(
      '${baseUrl}user-address',
      data: address.toJson(),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Ошибка добавления адреса: ${response.statusCode}');
    }
  }

  Future<void> deleteAddress(int id) async {
    final response = await dio.delete('${baseUrl}user-address/$id');
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Ошибка удаления адреса: ${response.statusCode}');
    }
  }
}
