import '../../data/models/user_address_model.dart';

abstract class UserAddressRepository {
  Future<List<UserAddressModel>> getAddresses();
  Future<void> addAddress(UserAddressModel address);
  Future<void> deleteAddress(int id);
}
