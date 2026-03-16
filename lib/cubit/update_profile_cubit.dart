import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/models/profile.dart';
import 'package:monkeyfood/repositories/profile_repositories.dart';
import 'package:monkeyfood/states/update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final ProfileRepositories _profileRepositories;

  UpdateProfileCubit(this._profileRepositories) : super(UpdateProfileInit());

  Future<void> updateUserProfile(Profile profile) async {
    emit(UpdatingProfile());

    try {
      await _profileRepositories.updateUserProfile(profile);

      emit(ProfileUpdated());
    } catch (e) {
      emit(UpdateProfileError(message: e.toString()));
    }
  }
}
