import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_cards_state.dart';

class AddCardsCubit extends Cubit<AddCardsState> {
  AddCardsCubit() : super(AddCardsInitial());
}
