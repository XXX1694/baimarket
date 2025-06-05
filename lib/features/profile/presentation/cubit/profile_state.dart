part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileGetting extends ProfileState {}

class ProfileGot extends ProfileState {
  final ProfileModel profile;
  const ProfileGot({required this.profile});
}

class ProfileGetError extends ProfileState {}
