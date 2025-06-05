part of 'main_cubit.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class MainInitial extends MainState {}

class BannerGetting extends MainState {}

class BannerGot extends MainState {
  final List<BannerModel> banners;
  const BannerGot({required this.banners});
}

class BannerGetError extends MainState {}
