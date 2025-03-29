import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_cards_state.dart';

class AddCardsCubit extends Cubit<AddCardsState> {
  AddCardsCubit() : super(AddCardsInitial());
}
