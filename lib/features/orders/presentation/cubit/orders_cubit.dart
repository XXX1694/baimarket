import 'package:bai_market/features/orders/data/datasources/order_services.dart';
import 'package:bai_market/features/orders/data/models/order_model.dart';
import 'package:bai_market/features/orders/domain/repositories/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrderRepository _orderRepository;
  OrdersCubit({OrderRepository? orderRepository})
    : _orderRepository = orderRepository ?? OrderServices(),
      super(OrdersInitial());

  Future<void> getOrders() async {
    emit(OrdersGetting());
    try {
      List<OrderModel> orders = await _orderRepository.getOrders();
      if (orders.isNotEmpty) {
        emit(OrdersGot(orders: orders));
      }
    } catch (e) {
      print(e);
      emit(OrdersGetError());
    }
  }
}
