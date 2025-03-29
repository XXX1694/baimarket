import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'make_order_state.dart';

class MakeOrderCubit extends Cubit<MakeOrderState> {
  MakeOrderCubit() : super(MakeOrderInitial());
}
