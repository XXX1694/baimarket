import 'package:bai_market/features/create_order/data/datasources/create_order_services.dart';
import 'package:bai_market/features/create_order/domain/repositories/create_order_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final CreateOrderRepository _createOrderRepository;
  CreateOrderCubit({CreateOrderRepository? createOrderRepository})
    : _createOrderRepository = createOrderRepository ?? CreateOrderServices(),
      super(CreateOrderInitial());
  Future<void> createOrder({
    required int cartId,
    required String fullName,
    required String phoneNumber,
    required bool selfPick,
    required String postalCode,
    required int cityId,
    required String deliveryAddress,
    required String comment,
    required String? pickupUrl,
    required String? selfPickDate,
    required int? filialId,
  }) async {
    emit(OrderCreating());
    try {
      String? res = await _createOrderRepository.createOrder(
        cartId: cartId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        selfPick: selfPick,
        postalCode: postalCode,
        cityId: cityId,
        deliveryAddress: deliveryAddress,
        comment: comment,
        pickupUrl: pickupUrl,
        selfPickDate: selfPickDate,
        filialId: filialId,
      );
      if (res != null) {
        emit(OrderCreated(paymentUrl: res));
      } else {
        emit(OrderCreateError());
      }
    } catch (e) {
      print(e);
      emit(OrderCreateError());
    }
  }
}
