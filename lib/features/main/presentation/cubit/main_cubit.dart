import 'package:bai_market/features/main/data/datasources/main_services.dart';
import 'package:bai_market/features/main/data/models/banner_model.dart';
import 'package:bai_market/features/main/domain/repositories/main_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final MainRepository _mainRepository;

  MainCubit({MainRepository? mainRepository})
    : _mainRepository = mainRepository ?? MainServices(),
      super(MainInitial()) {
    getBanners();
  }

  Future<void> getBanners() async {
    emit(BannerGetting());
    try {
      List<BannerModel> banners = await _mainRepository.getBanners();
      if (banners.isNotEmpty) {
        emit(BannerGot(banners: banners));
      } else {
        emit(BannerGetError());
      }
    } catch (e) {
      emit(BannerGetError());
    }
  }
}
