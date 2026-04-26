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
  final List<Object?> _signature;

  CartGot({required this.cart}) : _signature = _snapshot(cart);

  static List<Object?> _snapshot(CartModel cart) {
    final items = cart.cartItems ?? const <CartItemModel>[];
    final entries = <Object?>[
      cart.id,
      cart.totalPrice,
      items.length,
    ];
    for (final item in items) {
      entries.add('${item.model?.id ?? 0}:${item.quantity}');
    }
    return entries;
  }

  @override
  List<Object?> get props => _signature;
}

class CartGetError extends CartState {}

class CartGotAgain extends CartState {
  final CartModel cart;

  const CartGotAgain({required this.cart});

  @override
  List<Object?> get props => [identityHashCode(cart)];
}
