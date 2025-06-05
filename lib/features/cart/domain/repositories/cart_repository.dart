import '../../data/models/cart_model.dart';

abstract class CartRepository {
  Future<CartModel?> getCart();
  Future<bool> removeCart({required int id});
  Future<bool> addCart({required int id});
}
