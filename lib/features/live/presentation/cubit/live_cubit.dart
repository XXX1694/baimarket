import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'live_state.dart';

class LiveCubit extends Cubit<LiveState> {
  LiveCubit() : super(LiveInitial());
}
