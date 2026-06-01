part of 'create_order_cubit.dart';

abstract class CreateOrderState extends Equatable {
  const CreateOrderState();

  @override
  List<Object> get props => [];
}

class CreateOrderInitial extends CreateOrderState {}

class OrderCreating extends CreateOrderState {}

class OrderCreated extends CreateOrderState {
  final String paymentUrl;
  const OrderCreated({required this.paymentUrl});

  @override
  List<Object> get props => [paymentUrl];
}

class OrderCreateError extends CreateOrderState {
  final String? message;
  const OrderCreateError({this.message});

  @override
  List<Object> get props => [message ?? ''];
}
