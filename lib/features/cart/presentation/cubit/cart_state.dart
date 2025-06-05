part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartGetting extends CartState {}

class CartGot extends CartState {
  final CartModel cart;

  const CartGot({required this.cart});

  @override
  List<Object?> get props => [cart];
}

class CartGetError extends CartState {}

class CartGotAgain extends CartState {
  final CartModel cart;

  const CartGotAgain({required this.cart});

  @override
  List<Object?> get props => [cart];
}

class CartAdded extends CartState {
  final int id;

  const CartAdded({required this.id});

  @override
  List<Object?> get props => [id];
}

class CartAddError extends CartState {}

class CartRemoved extends CartState {
  final int id;

  const CartRemoved({required this.id});

  @override
  List<Object?> get props => [id];
}

class CartRemoveError extends CartState {}
