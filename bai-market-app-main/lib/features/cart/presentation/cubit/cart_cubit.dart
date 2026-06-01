import 'package:bai_market/features/cart/data/models/cart_model.dart';
import 'package:bai_market/features/cart/data/services/cart_services.dart';
import 'package:bai_market/features/cart/domain/repositories/cart_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;

  CartCubit({CartRepository? cartRepository})
    : _cartRepository = cartRepository ?? CartServices(),
      super(CartInitial());

  Future<void> getCart() async {
    emit(CartGetting());
    try {
      CartModel? cart = await _cartRepository.getCart();
      if (cart != null) {
        emit(CartGot(cart: cart));
      } else {
        emit(CartGetError());
      }
    } catch (e) {
      emit(CartGetError());
    }
  }

  Future<void> getCartAgain() async {
    try {
      CartModel? cart = await _cartRepository.getCart();
      if (cart != null) {
        emit(CartGotAgain(cart: cart));
      } else {
        emit(CartGetError());
      }
    } catch (e) {
      emit(CartGetError());
    }
  }

  Future<void> removeCart({required int id}) async {
    try {
      bool deleted = await _cartRepository.removeCart(id: id);
      if (deleted) {
        emit(CartRemoved(id: id));
      } else {
        emit(CartRemoveError());
      }
    } catch (e) {
      emit(CartRemoveError());
    }
  }

  Future<bool> addCart({required int id}) async {
    try {
      bool added = await _cartRepository.addCart(id: id);
      if (added) {
        emit(CartAdded(id: id));
        return true;
      } else {
        emit(CartAddError());
        return false;
      }
    } catch (e) {
      emit(CartAddError());
      return false;
    }
  }
}
