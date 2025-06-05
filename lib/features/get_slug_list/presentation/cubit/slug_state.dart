part of 'slug_cubit.dart';

abstract class SlugState extends Equatable {
  const SlugState();

  @override
  List<Object> get props => [];
}

class SlugInitial extends SlugState {}

class SlugGetting extends SlugState {}

class SlugGot extends SlugState {
  final List<SlugModel> slugs;
  const SlugGot({required this.slugs});
}

class SlugGetError extends SlugState {}
