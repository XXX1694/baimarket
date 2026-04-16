import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'prizes_state.dart';

class PrizesCubit extends Cubit<PrizesState> {
  PrizesCubit() : super(PrizesInitial());
}
