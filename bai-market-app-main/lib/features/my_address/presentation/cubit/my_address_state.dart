part of 'my_address_cubit.dart';

abstract class MyAddressState {}

class MyAddressInitial extends MyAddressState {}

class MyAddressLoading extends MyAddressState {}

class MyAddressLoaded extends MyAddressState {
  final List<UserAddressModel> addresses;
  MyAddressLoaded(this.addresses);
}

class MyAddressError extends MyAddressState {
  final String message;
  MyAddressError(this.message);
}
