import 'package:bai_market/features/profile/data/datasources/profile_services.dart';
import 'package:bai_market/features/profile/data/models/profile_model.dart';
import 'package:bai_market/features/profile/domain/repositories/profile_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit({ProfileRepository? profileRepository})
    : _profileRepository = profileRepository ?? ProfileServices(),
      super(ProfileInitial()) {
    getProfileData();
  }

  Future<void> getProfileData() async {
    emit(ProfileGetting());
    try {
      ProfileModel? profileModel = await _profileRepository.getProfileData();
      if (profileModel != null) {
        emit(ProfileGot(profile: profileModel));
      } else {
        emit(ProfileGetError());
      }
    } catch (e) {
      emit(ProfileGetError());
    }
  }
}
