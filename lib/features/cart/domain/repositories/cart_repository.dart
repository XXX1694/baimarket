import '../../data/models/cart_model.dart';

enum AddCartResult { success, unauthenticated, failed }

abstract class CartRepository {
  Future<CartModel?> getCart();
  Future<bool> removeCart({required int id});
  Future<AddCartResult> addCart({required int id});
}
