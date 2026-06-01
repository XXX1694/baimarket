import 'dart:async';

import 'package:bai_market/features/cart/data/models/cart_item_model.dart';
import 'package:bai_market/features/cart/data/models/cart_model.dart';
import 'package:bai_market/features/cart/data/services/cart_services.dart';
import 'package:bai_market/features/cart/domain/repositories/cart_repository.dart';
import 'package:bai_market/core/services/app_logger.dart';
import 'package:bai_market/features/product/data/models/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_state.dart';

sealed class CartEvent {
  const CartEvent();
}

class CartAddFailedEvent extends CartEvent {
  const CartAddFailedEvent();
}

class CartRemoveFailedEvent extends CartEvent {
  const CartRemoveFailedEvent();
}

class CartAddUnauthenticatedEvent extends CartEvent {
  final int productId;
  const CartAddUnauthenticatedEvent(this.productId);
}

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;
  final _events = StreamController<CartEvent>.broadcast();

  CartModel? _cart;

  CartCubit({CartRepository? cartRepository})
    : _cartRepository = cartRepository ?? CartServices(),
      super(CartInitial());

  Stream<CartEvent> get events => _events.stream;

  int quantityOf(int productId) {
    final items = _cart?.cartItems ?? const <CartItemModel>[];
    for (final item in items) {
      if (item.model?.id == productId) return item.quantity;
    }
    return 0;
  }

  void reset() {
    _cart = null;
    emit(CartInitial());
  }

  @override
  Future<void> close() {
    _events.close();
    return super.close();
  }

  Future<void> getCart() async {
    if (_cart == null) emit(CartGetting());
    try {
      final fresh = await _cartRepository.getCart();
      _cart = fresh ?? _emptyCart();
      _emitCart();
    } catch (_) {
      if (_cart == null) emit(CartGetError());
    }
  }

  Future<void> getCartAgain() async {
    try {
      final fresh = await _cartRepository.getCart();
      if (fresh != null) {
        _cart = fresh;
        emit(CartGotAgain(cart: fresh));
        _emitCart();
      } else {
        emit(CartGetError());
      }
    } catch (_) {
      emit(CartGetError());
    }
  }

  Future<bool> addCart({required int id, ProductModel? product}) async {
    cartLog.step('addCart', 'productId=$id');
    _applyDelta(id, 1, product: product);
    _emitCart();
    try {
      final result = await _cartRepository.addCart(id: id);
      cartLog.api('addCart result', result.name);
      switch (result) {
        case AddCartResult.success:
          unawaited(_syncFromServer());
          return true;
        case AddCartResult.unauthenticated:
          cartLog.warn('addCart unauthenticated → rollback + redirect');
          _applyDelta(id, -1);
          _emitCart();
          _events.add(CartAddUnauthenticatedEvent(id));
          return false;
        case AddCartResult.failed:
          cartLog.warn('addCart failed → rollback');
          _applyDelta(id, -1);
          _emitCart();
          _events.add(const CartAddFailedEvent());
          return false;
      }
    } catch (e, st) {
      cartLog.error('addCart exception', e.toString(), e, st);
      _applyDelta(id, -1);
      _emitCart();
      _events.add(const CartAddFailedEvent());
      return false;
    }
  }

  Future<void> clearCart() async {
    final items = List<CartItemModel>.from(_cart?.cartItems ?? []);
    _cart = _emptyCart();
    _emitCart();
    for (final item in items) {
      for (int i = 0; i < item.quantity; i++) {
        try {
          await _cartRepository.removeCart(id: item.model!.id);
        } catch (_) {}
      }
    }
    unawaited(_syncFromServer());
  }

  Future<void> removeCart({required int id}) async {
    if (quantityOf(id) <= 0) return;
    cartLog.step('removeCart', 'productId=$id, qtyBefore=${quantityOf(id)}');
    _applyDelta(id, -1);
    _emitCart();
    try {
      final ok = await _cartRepository.removeCart(id: id);
      cartLog.api('removeCart ok=$ok');
      if (!ok) {
        cartLog.warn('removeCart failed → rollback');
        _applyDelta(id, 1);
        _emitCart();
        _events.add(const CartRemoveFailedEvent());
      } else {
        unawaited(_syncFromServer());
      }
    } catch (e, st) {
      cartLog.error('removeCart exception', e.toString(), e, st);
      _applyDelta(id, 1);
      _emitCart();
      _events.add(const CartRemoveFailedEvent());
    }
  }

  Future<void> _syncFromServer() async {
    try {
      final fresh = await _cartRepository.getCart();
      _cart = fresh ?? _emptyCart();
      _emitCart();
    } catch (_) {/* keep optimistic state */}
  }

  void _emitCart() {
    _cart ??= _emptyCart();
    emit(CartGot(cart: _cart!));
  }

  void _applyDelta(int productId, int delta, {ProductModel? product}) {
    _cart ??= _emptyCart();
    final items = List<CartItemModel>.from(_cart!.cartItems ?? const []);
    final idx = items.indexWhere((i) => i.model?.id == productId);
    if (idx >= 0) {
      final item = items[idx];
      final newQty = item.quantity + delta;
      if (newQty <= 0) {
        items.removeAt(idx);
      } else {
        item.quantity = newQty;
      }
    } else if (delta > 0) {
      if (product == null) return;
      items.add(
        CartItemModel(
          id: 0,
          quantity: delta,
          totalPrice: (product.price ?? 0) * delta,
          model: product,
        ),
      );
    }
    int total = 0;
    for (final i in items) {
      total += (i.model?.price ?? 0) * i.quantity;
    }
    _cart = CartModel(
      id: _cart!.id,
      userId: _cart!.userId,
      totalPrice: total,
      cartItems: items,
      deliveryInfo: _cart!.deliveryInfo,
    );
  }

  CartModel _emptyCart() => CartModel(
        id: 0,
        userId: 0,
        totalPrice: 0,
        cartItems: <CartItemModel>[],
        deliveryInfo: null,
      );
}
