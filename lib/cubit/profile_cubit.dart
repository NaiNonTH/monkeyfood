import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/repositories/profile_repositories.dart';
import 'package:monkeyfood/states/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepositories profileRepositories;

  ProfileCubit(this.profileRepositories) : super(ProfileInit());

  Future<void> getUserProfile() async {
    emit(ProfileLoading());

    try {
      final user = await profileRepositories.getUserProfile();

      if (user == null) {
        emit(ProfileError(message: 'User is not logged in.'));
      } else {
        emit(ProfileLoaded(user: user));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
