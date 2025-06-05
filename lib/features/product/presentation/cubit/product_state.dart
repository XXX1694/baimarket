part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductGetting extends ProductState {}

class ProductGot extends ProductState {
  final ProductModel productModel;
  const ProductGot({required this.productModel});
}

class ProductGetError extends ProductState {}
