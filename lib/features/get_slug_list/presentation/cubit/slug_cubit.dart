import 'package:bai_market/features/get_slug_list/data/datasources/get_slug_list_services.dart';
import 'package:bai_market/features/get_slug_list/domain/repositories/get_slug_list_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/slug_model.dart';

part 'slug_state.dart';

class SlugCubit extends Cubit<SlugState> {
  final GetSlugListRepository _slugRepostory;

  SlugCubit({GetSlugListRepository? slugRepostory})
    : _slugRepostory = slugRepostory ?? GetSlugListServices(),
      super(SlugInitial()) {
    getSlugs();
  }

  Future<void> getSlugs() async {
    emit(SlugGetting());
    try {
      List<SlugModel> slugs = await _slugRepostory.getSlugs();
      slugs.insert(
        0,
        SlugModel(
          id: 999999,
          slug: 'all',
          nameKz: 'Бәрі',
          nameRu: 'Все',
          nameEn: 'All',
          iconUrl: '',
          createdAt: '',
          updatedAt: '',
        ),
      );

      if (slugs.isNotEmpty) {
        emit(SlugGot(slugs: slugs));
      } else {
        emit(SlugGetError());
      }
    } catch (e) {
      emit(SlugGetError());
    }
  }
}
