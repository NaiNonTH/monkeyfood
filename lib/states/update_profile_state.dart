abstract class UpdateProfileState {}

class UpdateProfileInit extends UpdateProfileState {}

class UpdatingProfile extends UpdateProfileState {}

class ProfileUpdated extends UpdateProfileState {}

class UpdateProfileError extends UpdateProfileState {
  final String message;

  UpdateProfileError({required this.message});
}
