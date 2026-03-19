import 'package:monkeyfood/models/profile.dart';

abstract class ProfileState {}

class ProfileInit extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile user;

  ProfileLoaded({required this.user});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
