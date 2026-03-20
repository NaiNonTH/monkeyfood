import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/repositories/profile_repositories.dart';
import 'package:monkeyfood/states/join_restaurant_state.dart';

class JoinRestaurantCubit extends Cubit<JoinRestaurantState> {
  final ProfileRepositories _profileRepositories;

  JoinRestaurantCubit(this._profileRepositories) : super(JoinRestaurantInit());

  Future<void> joinRestaurant(String joinCode) async {
    emit(JoiningRestaurant());

    try {
      await _profileRepositories.joinRestaurant(joinCode);

      emit(RestaurantJoined());
    } catch (e) {
      emit(JoinRestaurantError(message: e.toString()));
    }
  }

  Future<void> leaveRestaurant() async {
    emit(JoiningRestaurant());

    try {
      await _profileRepositories.leaveRestaurant();

      emit(RestaurantJoined());
    } catch (e) {
      emit(JoinRestaurantError(message: e.toString()));
    }
  }
}
