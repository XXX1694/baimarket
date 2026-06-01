import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_data_state.dart';

class MyDataCubit extends Cubit<MyDataState> {
  MyDataCubit() : super(MyDataInitial());
}
