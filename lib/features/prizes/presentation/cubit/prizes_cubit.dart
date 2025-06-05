import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'prizes_state.dart';

class PrizesCubit extends Cubit<PrizesState> {
  PrizesCubit() : super(PrizesInitial());
}
