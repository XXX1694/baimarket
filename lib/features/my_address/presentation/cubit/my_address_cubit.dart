import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_address_model.dart';
import '../../data/repositories/user_address_repository_impl.dart';

part 'my_address_state.dart';

class MyAddressCubit extends Cubit<MyAddressState> {
  final UserAddressRepositoryImpl repository;

  MyAddressCubit(this.repository) : super(MyAddressInitial());

  Future<void> loadAddresses() async {
    emit(MyAddressLoading());
    try {
      final addresses = await repository.getAddresses();
      emit(MyAddressLoaded(addresses));
    } catch (e) {
      emit(MyAddressError('Ошибка загрузки адресов'));
    }
  }

  Future<void> addAddress(UserAddressModel address) async {
    try {
      await repository.addAddress(address);
      await loadAddresses();
    } catch (e) {
      emit(MyAddressError('Ошибка добавления адреса'));
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      await repository.deleteAddress(id);
      await loadAddresses();
    } catch (e) {
      emit(MyAddressError('Ошибка удаления адреса'));
    }
  }
}
