part of 'orders_cubit.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersGetting extends OrdersState {}

class OrdersGot extends OrdersState {
  final List<OrderModel> orders;
  const OrdersGot({required this.orders});
}

class OrdersGetError extends OrdersState {}
